package com.spring.green2209S_17.service;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Calendar;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.green2209S_17.dao.CreateDAO;
import com.spring.green2209S_17.dao.PointDAO;
import com.spring.green2209S_17.vo.CompanyImgVO;
import com.spring.green2209S_17.vo.CompanyVO;
import com.spring.green2209S_17.vo.UserVO;

@Service
public class CreateServiceImpl implements CreateService {
	
	@Autowired
	CreateDAO createDAO;
	
	@Autowired
	JavaMailSender mailSender;
	
	@Autowired
	PointDAO pointDAO;
	
	@Override
	public UserVO getIdCheck(String mid) {
		return createDAO.getIdCheck(mid);
	}

	@Override
	public UserVO getEmailCheck(String email) {
		return createDAO.getEmailCheck(email);
	}

	@Override
	public UserVO getTelCheck(String tel) {
		return createDAO.getTelCheck(tel);
	}
	
	@Override
	public int setCreateUser_Step1(UserVO vo, String code) {
		int res = 0;
		res = createDAO.setCreateUser_Step1(vo,code);
		return res;
	}
	
	// 회원가입 인증 이메일 전송
	@Override
	public void sendActEmail(UserVO vo, String code, HttpServletRequest request) {
		try {
			String address = vo.getEmail();
			String title = vo.getMid() + "님의 인테모아 회원가입 인증메일입니다.";
			String content = "";
			
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
			
			messageHelper.setTo(address);
			messageHelper.setSubject(title);
			messageHelper.setText(content);
			
			String url = request.getServerName() + ":" + request.getServerPort()  + request.getContextPath();
			
			content = vo.getMid() + "님 아래 링크를 클릭하여 회원가입 절차를 이행해주세요.<p><br></p>";
			content += "<a href='http://"+url+"/create/actEmail?code="+code+"'>인증하기</a>";
			
			messageHelper.setText(content, true);
			
			mailSender.send(message);
			
		} catch (MessagingException e) {
			e.printStackTrace();
		}
	}

	@Override
	public UserVO searchCodeInfor(String code) {
		return createDAO.searchCodeInfor(code);
	}

	@Override
	public UserVO searchEmailInfor(String email) {
		return createDAO.searchEmailInfor(email);
	}

	@Override
	public int setUpdateEmailCode(String email, String code) {
		return createDAO.setUpdateEmailCode(email,code);
	}

	@Override
	public int setCreateUser_Step2(UserVO vo) {
		int res = 0;
		res = createDAO.setCreateUser_Step2Delete(vo);
		res = createDAO.setCreateUser_Step2Update(vo);
		return res;
	}

	@Override
	public CompanyVO getCpIdCheck(String mid) {
		return createDAO.getCpIdCheck(mid);
	}

	@Override
	public CompanyVO getCpNameCheck(String cpName) {
		return createDAO.getCpNameCheck(cpName);
	}

	@Override
	public int setCreateCompany(CompanyVO cpVO, CompanyImgVO cpImgVO) {
		int res = createDAO.setCreateCompany(cpVO);
		if(res == 0) return res;
		cpVO = createDAO.getCpIdCheck(cpVO.getMid());
		if(cpImgVO.getCpImg().equals("")) cpImgVO.setCpImg("noLogo.png");
		res = createDAO.setCreateCompanyImg(cpVO.getIdx(),cpImgVO);
		return res;
	}

	@Override
	public void saveImg(HttpServletRequest request, MultipartHttpServletRequest file, String fileName) {
		Calendar cal = Calendar.getInstance();
		String sFileName = cal.get(Calendar.YEAR) + "";
		sFileName += reDate(cal.get(Calendar.MONTH));
		sFileName += reDate(cal.get(Calendar.DATE));
		sFileName += reDate(cal.get(Calendar.HOUR));
		sFileName += reDate(cal.get(Calendar.MINUTE));
		sFileName += reDate(cal.get(Calendar.SECOND));
		sFileName += reDate(cal.get(Calendar.MILLISECOND))+"_"+fileName;
		
		MultipartFile realFile = file.getFile("cpImg");
		try {
			byte[] data = realFile.getBytes();
			String realPath = request.getSession().getServletContext().getRealPath("/resources/images/cpProfile/");
			FileOutputStream fos = new FileOutputStream(realPath+sFileName);
			fos.write(data);
			fos.close();
			createDAO.saveImgUpdate(fileName,sFileName);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private String reDate(int date) {
		if(Integer.toString(date).length() == 1) return "0" + date;
		return date + "";
	}
	
}
