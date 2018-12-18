package com.fl.live.service;

import com.fl.model.AppAttention;

public interface LiveAttentionService {
    public boolean isgz(String pguid, String lguid);

    public String insert(AppAttention model);

    public String deleteByGzid(String pguid, String lguid);
}
