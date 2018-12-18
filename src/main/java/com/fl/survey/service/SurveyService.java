package com.fl.survey.service;

import com.fl.model.*;

import java.util.List;

public interface SurveyService {
    public SSurvey getSingle(String sid);

    public List<QA> getQuestionBySid(String sid);

    public List<SAnswer> getAnswerBySid(String sid);

    public List<SAnswer> getAnswerCountBySid(String sid);

    public String getList(int currentPage, int pagesize, SSurvey model);

    public int insert(SSurvey model, List<SQuestion> qlist, List<SAnswer> alist);

    public int updateBySid(SSurvey model, List<SQuestion> qlist, List<SAnswer> alist);

    public int deleteBySid(String sid);

    public int updateIseditBySid(String sid);

    public int replyAdd(List<SReply> list);

    public boolean isReply(String tel, String sid);

    public boolean isReplyByOpenid(String openid, String sid);
}
