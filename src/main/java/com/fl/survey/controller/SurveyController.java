package com.fl.survey.controller;

import com.fl.common.CommonHelp;
import com.fl.common.TypeUtils;
import com.fl.model.*;
import com.fl.survey.service.SurveyService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/survey")
public class SurveyController {
    @Resource
    private SurveyService surveyService;

    @RequestMapping(value = "/list")
    public ModelAndView SurveyList() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/manager/survey_list");
        return mv;
    }

    @RequestMapping(value = "/mysurvey")
    public ModelAndView MySurvey() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/manager/survey_mylist");
        return mv;
    }

    @RequestMapping(value = "/create")
    public ModelAndView CreateSurvey() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/manager/survey_create");
        mv.addObject("bz", "1");
        return mv;
    }

    @RequestMapping(value = "/update")
    public ModelAndView UpdateShow(String sid) {
        ModelAndView mv = new ModelAndView();
        SSurvey sm = surveyService.getSingle(sid);
        mv.addObject("sm", sm);
        List<QA> qlist = surveyService.getQuestionBySid(sid);
        mv.addObject("qlist", qlist);
        mv.addObject("bz", "0");
        mv.setViewName("/manager/survey_create");
        return mv;
    }

    @RequestMapping(value = "/answer")
    public ModelAndView Answer(String sid) {
        ModelAndView mv = new ModelAndView();
        SSurvey sm = surveyService.getSingle(sid);
        mv.addObject("sm", sm);
        List<QA> qlist = surveyService.getQuestionBySid(sid);
        mv.addObject("qlist", qlist);
        List<SAnswer> alist = surveyService.getAnswerBySid(sid);
        mv.addObject("alist", alist);
        mv.addObject("bz", "0");
        mv.setViewName("/manager/survey_answer");
        surveyService.updateIseditBySid(sid);
        return mv;
    }

    @RequestMapping(value = "/answer2")
    public ModelAndView Answer2(String sid) {
        ModelAndView mv = new ModelAndView();
        SSurvey sm = surveyService.getSingle(sid);
        mv.addObject("sm", sm);
        List<QA> qlist = surveyService.getQuestionBySid(sid);
        mv.addObject("qlist", qlist);
        List<SAnswer> alist = surveyService.getAnswerBySid(sid);
        mv.addObject("alist", alist);
        mv.addObject("bz", "0");
        mv.setViewName("/manager/survey_answer2");
        surveyService.updateIseditBySid(sid);
        return mv;
    }

    @RequestMapping(value = "/answer2/message")
    public ModelAndView Message() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/manager/survey_message");
        return mv;
    }

    @RequestMapping(value = "/tj")
    public ModelAndView TJ(String sid) {
        ModelAndView mv = new ModelAndView();
        SSurvey sm = surveyService.getSingle(sid);
        mv.addObject("sm", sm);
        List<QA> qlist = surveyService.getQuestionBySid(sid);
        mv.addObject("qlist", qlist);
        List<SAnswer> alist = surveyService.getAnswerCountBySid(sid);
        mv.addObject("alist", alist);
        mv.addObject("bz", "0");
        mv.setViewName("/manager/survey_tj");
        surveyService.updateIseditBySid(sid);
        return mv;
    }

    @ResponseBody
    @RequestMapping(value = "/getList")
    public String getList(int currentPage, int pagesize, SSurvey model) {
        return surveyService.getList(currentPage, pagesize, model);
    }

    @ResponseBody
    @RequestMapping(value = "/add")
    public String Add(SSurvey model, String qstr) {
        String sid = CommonHelp.getUuid();
        Session session = SecurityUtils.getSubject().getSession();
        String displayname = (String) session.getAttribute("displayname");
        String pguid = (String) session.getAttribute("pguid");
        model.setSid(sid);
        model.setCreatetime(new Date());
        model.setDisplayname(displayname);
        model.setPguid(pguid);
        List<SQuestion> qlist = new ArrayList<SQuestion>();
        List<SAnswer> alist = new ArrayList<SAnswer>();
        try {
            if (!TypeUtils.isEmpty(qstr)) {
                List<Map<String, Object>> obj = (List<Map<String, Object>>) CommonHelp.ConvertToOjb(qstr);
                for (int i = 0; i < obj.size(); i++) {
                    SQuestion sq = new SQuestion();
                    String qid = CommonHelp.getUuid();
                    sq.setQid(qid);
                    sq.setSid(sid);
                    String qcata = (String) obj.get(i).get("qcata");
                    sq.setQcata(qcata);
                    String qindex = (String) obj.get(i).get("qindex");
                    sq.setQindex(qindex);
                    String qtitle = (String) obj.get(i).get("qtitle");
                    sq.setQtitle(qtitle);
                    qlist.add(sq);
                    List<String> arr = (List<String>) obj.get(i).get("xx");
                    for (int j = 0; j < arr.size(); j++) {
                        SAnswer sa = new SAnswer();
                        sa.setAid(CommonHelp.getUuid());
                        sa.setQid(qid);
                        sa.setAtext(arr.get(j));
                        sa.setSid(sid);
                        sa.setAsort(String.valueOf(j+1));
                        alist.add(sa);
                    }
                }
            }
        } catch (Exception e) {
            return "";
        }
        return String.valueOf(surveyService.insert(model, qlist, alist));
    }

    @ResponseBody
    @RequestMapping(value = "/startupdate")
    public String StartUpdate(SSurvey model, String qstr) {
        String sid = model.getSid();
        Session session = SecurityUtils.getSubject().getSession();
        String displayname = (String) session.getAttribute("displayname");
        String pguid = (String) session.getAttribute("pguid");
        model.setDisplayname(displayname);
        model.setPguid(pguid);
        List<SQuestion> qlist = new ArrayList<SQuestion>();
        List<SAnswer> alist = new ArrayList<SAnswer>();
        try {
            if (!TypeUtils.isEmpty(qstr)) {
                List<Map<String, Object>> obj = (List<Map<String, Object>>) CommonHelp.ConvertToOjb(qstr);
                for (int i = 0; i < obj.size(); i++) {
                    SQuestion sq = new SQuestion();
                    String qid = CommonHelp.getUuid();
                    sq.setQid(qid);
                    sq.setSid(sid);
                    String qcata = (String) obj.get(i).get("qcata");
                    sq.setQcata(qcata);
                    String qindex = (String) obj.get(i).get("qindex");
                    sq.setQindex(qindex);
                    String qtitle = (String) obj.get(i).get("qtitle");
                    sq.setQtitle(qtitle);
                    qlist.add(sq);
                    List<String> arr = (List<String>) obj.get(i).get("xx");
                    for (int j = 0; j < arr.size(); j++) {
                        SAnswer sa = new SAnswer();
                        sa.setAid(CommonHelp.getUuid());
                        sa.setQid(qid);
                        sa.setAtext(arr.get(j));
                        sa.setSid(sid);
                        sa.setAsort(String.valueOf(j+1));
                        alist.add(sa);
                    }
                }
            }
        } catch (Exception e) {
            return "";
        }
        return String.valueOf(surveyService.updateBySid(model, qlist, alist));
    }

    @ResponseBody
    @RequestMapping(value = "/delbysid")
    public String DelBySid(String sid) {
        return String.valueOf(surveyService.deleteBySid(sid));
    }

    /**************************************问卷调查 回复**********************************************************/
    @ResponseBody
    @RequestMapping(value = "/reply/add")
    public String ReplyAdd(SReply model, String rstr) {
        String tel = model.getTel();
        String sid = model.getSid();
        String openid = model.getOpenid();
        if (surveyService.isReply(tel, sid)) {
            return "3";
        }
        if (!TypeUtils.isEmpty(openid)) {
            if (surveyService.isReplyByOpenid(openid, sid)) {
                return "4";
            }
        }
        List<SReply> list = new ArrayList<SReply>();
        if (!TypeUtils.isEmpty(rstr)) {
            List<Map<String, String>> obj = (List<Map<String, String>>) CommonHelp.ConvertToOjb(rstr);
            for (int i = 0; i < obj.size(); i++) {
                SReply sr = new SReply();
                String qid = obj.get(i).get("qid");
                String aid = obj.get(i).get("aid");
                sr.setRid(CommonHelp.getUuid());
                sr.setDisplayname(model.getDisplayname());
                sr.setCompany(model.getCompany());
                sr.setTel(model.getTel());
                sr.setCreatetime(new Date());
                sr.setSid(model.getSid());
                sr.setQid(qid);
                sr.setAtext(aid);
                sr.setOpenid(openid);
                list.add(sr);
            }
        }
        int rows = surveyService.replyAdd(list);
        if (rows == 0) {
            return "0";
        } else {
            return "1";
        }
    }
}
