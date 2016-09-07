#!/usr/bin/python
import numpy as np
import scipy.sparse
import cPickle
import xgboost as xgb
import sys
import scipy.io as sio

missing = -999

def load_data(fin):
    data = sio.loadmat(fin)['data'][0][0]
#    data = data['data'].f 
    f = np.array(data[0])
    if len(data) > 1:
        print len(data[0])
        l = np.array(data[1])
        if l.shape[1] > 1:
            l = l.T
        l[l == -1] = 0
        dtrain = xgb.DMatrix(f, l, missing=missing)
    else:
        dtrain = xgb.DMatrix(f, missing=missing)
    
    return dtrain


def xgbTrain(fdata, sav_model):
    data = load_data(fdata)
    watchlist = [(data, 'train')]
    
    param = {
        'objective': 'binary:logistic', 
        # 'eval_metric': 'rmse', 
        'bst:eta': 0.02, 
        'subsample': 0.7,
        'bst:max_depth': 2, 
        'gamma': 0, 
        'min_child_weight': 0, 
        'lambda': 0,
     #   'colsample_bytree' : 0.8, 
        'seed' : 421
        }
    num_round = 20
    bst = xgb.train(param, data, num_round, watchlist)
    
 #   preds = bst.predict(data)
#    labels = data.get_label()
 #   print ('error=%f' % ( sum(1 for i in range(len(preds)) if int(preds[i]>0.5)!=labels[i]) /float(len(preds))))


    bst.save_model(sav_model)
    
def xgbPredict(fdata, sav_model):
    d = load_data(fdata)
    bst = xgb.Booster(model_file=sav_model)
    preds = bst.predict(d)
    
    data = {};
    data['l'] = np.array([1 if p > 0.5 else -1 for p in preds])
    data['prob'] = np.array([(p, 1-p) for p in preds])
    sio.savemat(fdata, data)
    
  

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print "error! python xgboost.py mode fdata fmodel"
    else: 
        if sys.argv[1] == 'train':
            xgbTrain(sys.argv[2], sys.argv[3])
        else:
            xgbPredict(sys.argv[2], sys.argv[3])
