function [label, prob] = test_xgboost(f, fdata, model_name)
    data.f = f;
    save(fdata, 'data');
    system(sprintf('python xgboost_py.py test %s %s', fdata, model_name));
    data = load(fdata);
    label = data.l;
    prob = data.prob;
end
