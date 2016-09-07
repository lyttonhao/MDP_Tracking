function [] = train_xgboost(f, l, fdata, model_name)
    data.f = f;
    data.l = l;
    save(fdata, 'data');
    system(sprintf('python xgboost_py.py train %s %s', fdata, model_name));
end
