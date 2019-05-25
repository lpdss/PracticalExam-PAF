package com.payment.servlet;

public class paymentServlet {

import java.io.IOException;

/**
 * Servlet implementation class paymentServlet
 */
@WebServlet("/paymentServlet")
public class paymentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public paymentServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/paymentProduct.jsp");
		dispatcher.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");

		HttpSession session = request.getSession();
		session.setAttribute("productName", request.getParameter("name"));
		session.setAttribute("productAmount", request.getParameter("amount"));
		session.setAttribute("productQuantity", request.getParameter("quantity"));
	}

}
