package com.ducetech.hadmin.entity;

import com.ducetech.hadmin.entity.support.BaseEntity;
import lombok.Data;

import javax.persistence.*;
import java.text.DecimalFormat;

/**
 * 文件管理
 *
 * @author lisx
 * @create 2017-08-04 13:54
 **/
@Entity
@Table(name = "big_notice")
@Data
public class Notice extends BaseEntity {
    private static final long serialVersionUID=1L;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id",nullable = false)
    private Integer id;
    //通知标题
    private String title;
    //通知内容
    private String content;
    //站区
    private String areaName;
    //站点
    private String stationName;
    //是否使用
    private String ifUse;
}
