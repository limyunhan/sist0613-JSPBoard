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
 * Servlet implementation class SendProcServlet
 */
@WebServlet("/sendProc")
public class SendProcServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SendProcServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
		System.out.println("SendProcServlet init()......");
	}

	/**
	 * @see Servlet#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
		System.out.println("SendProcServlet destroy()......");
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("SendProcServlet doGet()......");
		process(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("SendProcServlet doPost()......");
		process(request, response);
	}
	
	private void process(HttpServletRequest request, HttpServletResponse response) 
											throws ServletException, IOException 
	{
		System.out.println("SendProcServlet process()......");
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		
		String method = request.getMethod();
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		
		PrintWriter writer = response.getWriter();
		
		writer.println("<!DOCTYPE html>");
		writer.println("<html>");
		writer.println("<head>");
		writer.println("<meta charset=\"UTF-8\">");	
		writer.println("	<title>sendProc</title>");	
		writer.println("		</head>");	
		
		writer.println("		<body>");		
		writer.println("			method :" + method);	
		writer.println("			<br />");		
		writer.println("			name :" + name);		
		writer.println("			<br />");		
		writer.println("			email :" + email);	
		writer.println("				</body>");		
		writer.println("		</html>");	
		
	}

}
