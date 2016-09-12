function [dres] = cal_extra_feat(dres)
    num = numel(dres.fr);
    dres.max_overlap = zeros(num, 1);
    dres.cnt_overlap = zeros(num, 1);
    for i = 1:num
        % calculate overlaps between detection bboxes
        fr = dres.fr(i);
        index = find(dres.fr == fr);
        index(find(index == i)) = [];
        if isempty(index) == 0
            overlap = calc_overlap(dres, i, dres, index);
            o = max(overlap);
            dres.max_overlap(i) = o;
            dres.cnt_overlap(i) = sum(overlap >= 0.05);
        end
    end
end
