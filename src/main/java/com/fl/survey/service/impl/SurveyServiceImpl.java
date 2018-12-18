package com.fl.survey.service.impl;

import com.fl.common.CommonHelp;
import com.fl.common.TypeUtils;
import com.fl.mapper.SAnswerMapper;
import com.fl.mapper.SQuestionMapper;
import com.fl.mapper.SReplyMapper;
import com.fl.mapper.SSurveyMapper;
import com.fl.model.*;
import com.fl.survey.service.SurveyService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class SurveyServiceImpl implements SurveyService {
    @Resource
    private SSurveyMapper sSurveyMapper;
    @Resource
    private SQuestionMapper sQuestionMapper;
    @Resource
    private SAnswerMapper sAnswerMapper;
    @Resource
    private SReplyMapper sReplyMapper;

    public SSurvey getSingle(String sid) {
        return sSurveyMapper.getSingle(sid);
    }

    /**
     * 获取问题和问题答案选项
     *
     * @param sid
     * @return
     */
    public List<QA> getQuestionBySid(String sid) {
        List<SQuestion> list = sQuestionMapper.getListBySid(sid);
        List<QA> qalist = new ArrayList<QA>();
        for (int i = 0; i < list.size(); i++) {
            QA qa = new QA();
            String str = list.get(i).getSid();
            if (!TypeUtils.isEmpty(str)) {
                str = str.substring(0, str.length() - 1);
                List<String> xxxxxxxx = Arrays.asList(str.split(","));
                qa.setXx(xxxxxxxx);
            }
            qa.setsQuestion(list.get(i));
            qalist.add(qa);
        }
        return qalist;
    }

    /**
     * 获取问卷调查的所有答案
     *
     * @param sid
     * @return
     */
    public List<SAnswer> getAnswerBySid(String sid) {
        return sAnswerMapper.selectBySid(sid);
    }

    public List<SAnswer> getAnswerCountBySid(String sid) {
        return sAnswerMapper.selectAnswerCt(sid);
    }

    @Override
    public String getList(int currentPage, int pagesize, SSurvey model) {
        if (!TypeUtils.isNumeric(String.valueOf(currentPage))) {
            currentPage = 1;
        }
        if (!TypeUtils.isNumeric(String.valueOf(pagesize))) {
            pagesize = 10;
        }
        PageHelper.startPage(currentPage, pagesize);
        List<SSurvey> list = sSurveyMapper.getList(model);
        PageInfo<SSurvey> pageinfo = new PageInfo<SSurvey>(list);
        int totalcount = (int) pageinfo.getTotal();
        String json;
        try {
            json = "{\"code\": \"0\", \"msg\": \"\",\"count\": \"" + totalcount + "\",\"data\":"
                    + CommonHelp.ConvertToJson(list) + "}";
        } catch (Exception e) {
            json = "{\"code\": \"1\", \"msg\": \"\",\"count\":0,data:[]}";
        }
        return json;
    }

    @Override
    public int insert(SSurvey model, List<SQuestion> qlist, List<SAnswer> alist) {
        try {
            sQuestionMapper.deleteBySid(model.getSid());
            sQuestionMapper.insertList(qlist);
            sAnswerMapper.deleteBySid(model.getSid());
            sAnswerMapper.insertList(alist);
            int rows = sSurveyMapper.insert(model);
            return rows;
        } catch (Exception e) {
            return 0;
        }
    }

    @Override
    public int updateBySid(SSurvey model, List<SQuestion> qlist, List<SAnswer> alist) {
        try {
            sQuestionMapper.deleteBySid(model.getSid());
            sQuestionMapper.insertList(qlist);
            sAnswerMapper.deleteBySid(model.getSid());
            sAnswerMapper.insertList(alist);
            int rows = sSurveyMapper.updateBySid(model);
            return rows;
        } catch (Exception e) {
            return 0;
        }
    }

    @Override
    public int deleteBySid(String sid) {
        try {
            sQuestionMapper.deleteBySid(sid);
            sAnswerMapper.deleteBySid(sid);
            int rows = sSurveyMapper.deleteBySid(sid);
            return rows;
        } catch (Exception e) {
            return 0;
        }
    }

    /**
     * 答题过后，将不能修改调查题目
     *
     * @param sid
     * @return
     */
    public int updateIseditBySid(String sid) {
        try {
            int rows = sSurveyMapper.updateisedit(sid);
            return rows;
        } catch (Exception e) {
            return 0;
        }
    }

    /*******************************************************************************************/
    public int replyAdd(List<SReply> list) {
        try {
            int rows = sReplyMapper.insert(list);
            return rows;
        } catch (Exception e) {
            return 0;
        }
    }

    /**
     * 手机号是否调查过
     *
     * @param tel
     * @param sid
     * @return
     */
    public boolean isReply(String tel, String sid) {
        List<SReply> m = sReplyMapper.selectIsReply(tel, sid);
        if (m == null || m.size() < 1) {
            return false;
        } else {
            return true;
        }
    }

    /**
     * 每个手机号只能调查一次
     *
     * @param openid
     * @param sid
     * @return
     */
    public boolean isReplyByOpenid(String openid, String sid) {
        List<SReply> m = sReplyMapper.selectIsReplyByOpenid(openid, sid);
        if (m == null || m.size() < 1) {
            return false;
        } else {
            return true;
        }
    }
}
