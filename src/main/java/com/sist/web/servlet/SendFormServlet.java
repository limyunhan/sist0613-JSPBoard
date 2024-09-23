package com.sist.web.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class SendFormServlet
 */
@WebServlet("/sendForm")
public class SendFormServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SendFormServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
		System.out.println("SendFormServlet init()......");
	}

	/**
	 * @see Servlet#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
		System.out.println("SendFormServlet destory().....");
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("SendFormServlet doGet().....");
		process(request, response);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("SendFormServlet doPost()....");
		process(request, response);
	}
	
	private void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		System.out.println("SendFormServlet process()....");
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter writer = response.getWriter();
		
		writer.println("<!DOCTYPE html>");
		writer.println("<html>");
		writer.println("	<head>");
		writer.println("		<meta charset=\"UTF-8\">");
		writer.println("		<title>sendForm</title>");	
		writer.println("	</head>");
		writer.println("	<body>");
		writer.println("		<a href=\"/sendProc?name=쌍용강북&email=sist@dame.net\"> GET 방식 전송</a>");
		writer.println("		<br /><br />");	
		writer.println("		<form name=\"form1\" method=\"post\" action=\"/sendProc\">");		
		writer.println("			이름 : <input type=\"text\" name=\"name\" style=\"width:200px;\" />");
		writer.println("			<br />");	
		writer.println("			이메일 : <input type=\"text\" name=\"email\" style=\"width:200px;\" />");	
		writer.println("			<br />");	
		writer.println("			<button onClick=\"submit\"> POST 방식 전송</button>");	
		writer.println("		</form>");
		writer.println("	</body>");
		writer.println("</html>");
	}

}
