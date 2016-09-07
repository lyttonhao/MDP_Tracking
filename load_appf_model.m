
function [tracker] = load_appf_model(tracker, opt)

tracker.use_model = opt.use_model;
tracker.appf_model = mxnet.model;
tracker.appf_model.load(opt.appf_model, opt.appf_model_epoch);
load(opt.appf_mean);
tracker.appf_mean = mean_img;
tracker.appf_featsize = opt.appf_featsize;
tracker.appf_patchsize = opt.appf_patchsize;

tracker.appf_car_model = mxnet.model;
tracker.appf_car_model.load(opt.appf_car_model, opt.appf_car_model_epoch);
load(opt.appf_car_mean);
tracker.appf_car_mean = mean_img;
tracker.appf_car_patchsize = opt.appf_car_patchsize;
