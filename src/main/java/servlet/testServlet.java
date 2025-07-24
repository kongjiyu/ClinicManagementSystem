package servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Schedule;
import repositories.Schedule.ScheduleRepository;

import utils.ArrayList;

import java.io.IOException;

@WebServlet("/test/output")
public class testServlet extends HttpServlet {
  @Inject
  ScheduleRepository scheduleRepository;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String yearParam = req.getParameter("year");
    String monthParam = req.getParameter("month");

    Integer year = Integer.parseInt(yearParam);
    Integer month = Integer.parseInt(monthParam);

    ArrayList<Schedule> schedules = scheduleRepository.findByMonth(year, month);
    for (Schedule schedule : schedules) {
      System.out.println(schedule.getScheduleID());
    }


  }

}