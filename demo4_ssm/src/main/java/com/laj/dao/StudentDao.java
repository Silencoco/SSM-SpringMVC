package com.laj.dao;

import com.laj.domain.Student;

import java.util.List;

public interface StudentDao {

    //插入
    int insertStudent(Student student);
    //查询
    List<Student> selectStudents();
}
