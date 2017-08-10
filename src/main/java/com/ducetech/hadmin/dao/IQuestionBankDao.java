package com.ducetech.hadmin.dao;

import com.ducetech.hadmin.dao.support.IBaseDao;
import com.ducetech.hadmin.entity.Proper;
import com.ducetech.hadmin.entity.QuestionBank;
import org.springframework.stereotype.Repository;

/**
 * 文件管理
 *
 * @author lisx
 * @create 2017-08-01 15:46
 **/
@Repository
public interface IQuestionBankDao extends IBaseDao<QuestionBank,Integer> {

    QuestionBank findByName(String name);
}
