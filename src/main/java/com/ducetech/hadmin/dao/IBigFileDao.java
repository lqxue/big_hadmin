package com.ducetech.hadmin.dao;

import com.ducetech.hadmin.dao.support.IBaseDao;
import com.ducetech.hadmin.entity.BigFile;
import com.ducetech.hadmin.entity.Notice;
import com.ducetech.hadmin.entity.Station;
import com.ducetech.hadmin.entity.User;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 文件管理
 *
 * @author lisx
 * @create 2017-08-01 15:46
 **/
@Repository
public interface IBigFileDao extends IBaseDao<BigFile,Integer> {
    @Query(value="select o from BigFile o where o.stationFile=:station ")
    List<BigFile> findByStation(@Param("station") Station station);
    @Query(value="select o from BigFile o where (o.nodeCode like:station or o.nodeCode=:ys or  o.nodeCode=:area ) and o.ifUse=0 and o.menuType=:menuType ")
    List<BigFile> findByStationFileOrStationFileAndMenuType(@Param("station") String station,@Param("ys") String ys,@Param("area") String area,@Param("menuType") String menuType);
    @Query(value="select o from BigFile o where (o.nodeCode like:station or o.nodeCode=:ys or  o.nodeCode=:area ) and o.ifUse=0  and o.menuType=:menuType and o.fileName like:name")
    List<BigFile> findByStationFileOrStationFileAndMenuTypeAndFileName(@Param("station") String station,@Param("ys") String ys,@Param("area") String area,@Param("menuType") String menuType,@Param("name") String name);
    BigFile findByFileName(String folder);

    BigFile findByFileNameAndMenuType(String folder,String menuType);

    List<BigFile> findByFolderFile(BigFile file);

    List<BigFile> findByMenuType(String menuType);

    List<BigFile> findByNotice(Notice notice);

    List<BigFile> findByMd5(String md5);
}
