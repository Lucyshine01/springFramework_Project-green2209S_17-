package com.spring.green2209S_17.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.green2209S_17.dao.CompanyDAO;
import com.spring.green2209S_17.dao.CreateDAO;
import com.spring.green2209S_17.dao.MemberDAO;
import com.spring.green2209S_17.dao.PointDAO;
import com.spring.green2209S_17.dao.ReplyDAO;
import com.spring.green2209S_17.pagination.PageProcess;
import com.spring.green2209S_17.pagination.PageVO;
import com.spring.green2209S_17.vo.CompanyImgVO;
import com.spring.green2209S_17.vo.CompanyVO;
import com.spring.green2209S_17.vo.HelpVO;
import com.spring.green2209S_17.vo.PointVO;
import com.spring.green2209S_17.vo.ReplyVO;
import com.spring.green2209S_17.vo.UserVO;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	MemberDAO memberDAO;
	
	@Autowired
	CreateDAO createDAO;
	
	@Autowired
	CompanyDAO companyDAO;
	
	@Autowired
	ReplyDAO replyDAO;
	
	@Autowired
	PointDAO pointDAO;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Override
	public String loginCheck(String mid, String pwd, String rememId, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) {
		
		String res = "0";
		String url = "";
		
		if(rememId.equals("on")) {
			Cookie cookieId = new Cookie("cMid", mid);
			cookieId.setPath("/");
			cookieId.setMaxAge(60*60*24*7);
			response.addCookie(cookieId);
		}
		else {
			Cookie cookieId = new Cookie("cMid", null);
			cookieId.setPath("/");
			cookieId.setMaxAge(0);
			response.addCookie(cookieId);
		}
		
		
		// 이전페이지 주소확인 (사파리 작동x)
		if(request.getHeader("referer") != null) url = request.getHeader("referer");
		else url = request.getContextPath() + "/";
		
		UserVO vo = createDAO.getIdCheck(mid);
		
		try {
			if(vo.getAccStop() != null) {
				Date now = new Date();
				if(now.before(vo.getAccStop())) {
					res = "4";
					SimpleDateFormat format = new SimpleDateFormat("yyyy년 MM월 dd일");
					url = "해당 계정은 "+format.format(vo.getAccStop())+"<br/>이후에 정상 사용이 가능합니다.";
					return res+url;
				}
				else createDAO.accStopDateDefault(vo.getIdx());
			}
		} catch (NullPointerException e) {}
		
		if(vo != null && passwordEncoder.matches(pwd, vo.getPwd())) {
			res = "1";
			session.setAttribute("sMid", vo.getMid());
			session.setAttribute("sUserLevel", vo.getUserLevel());
			session.setAttribute("sProfileImg", vo.getProfile());
		}
		else if(vo == null) res = "2";
		else if(vo.getPwd().equals("NoPwd")) res="3";
		
		return res+url;
	}

	@Override
	public UserVO getUserInfo(String mid) {
		return createDAO.getIdCheck(mid);
	}

	@Override
	public int inputCPImg(MultipartHttpServletRequest file, HttpServletRequest request, String mid) {
		CompanyVO cpVO = createDAO.getCpIdCheck(mid);
		CompanyImgVO cpImgVO = companyDAO.getCpImgInfo(cpVO.getIdx());
		String cpIntroImg = cpImgVO.getCpIntroImg();
		Iterator<String> fileNames = file.getFileNames();
		while(fileNames.hasNext()) {
			String fileName = fileNames.next();
			MultipartFile fileIdx = file.getFile(fileName);
			String oriFileName = fileIdx.getOriginalFilename();
			
			if(oriFileName.equals("")) break;
			
			UUID uid = UUID.randomUUID();
			String randomStr = uid.toString().substring(0,8);
			
			if(cpIntroImg.length() != 0) cpIntroImg += "/";
			cpIntroImg += randomStr + "_" + oriFileName + ":" + oriFileName;
			
			try {
				byte[] data = fileIdx.getBytes();
				String realPath = request.getSession().getServletContext().getRealPath("/resources/images/cpIntro/");
				FileOutputStream fos = new FileOutputStream(realPath+randomStr+"_"+oriFileName);
				fos.write(data);
				fos.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		cpImgVO.setCpIntroImg(cpIntroImg);
		
		return companyDAO.setSaveCpImg(cpImgVO);
	}


	@Override
	public void profileChange(MultipartHttpServletRequest file, HttpServletRequest request, UserVO vo, HttpSession session) {
		MultipartFile profileFile = file.getFile("profile");
		
		UUID uid = UUID.randomUUID();
		String randomStr = uid.toString().substring(0,8);
		
		String oriName = profileFile.getOriginalFilename();
		String sysName = randomStr + "_" + oriName;
		try {
			byte[] data = profileFile.getBytes();
			String realPath = request.getSession().getServletContext().getRealPath("/resources/images/profile/");
			FileOutputStream fos = new FileOutputStream(realPath+sysName);
			fos.write(data);
			fos.close();
			if(!vo.getProfile().equals("default.jpg")) new File(realPath+vo.getProfile()).delete();
			session.removeAttribute("sProfileImg");
			session.setAttribute("sProfileImg",sysName);
		} catch (IOException e) {
			e.printStackTrace();
		}
		memberDAO.updateUserProfile(sysName,vo.getMid());
	}
	
	@Override
	public void profileDefault(UserVO vo, HttpServletRequest request, HttpSession session) {
		String realPath = request.getSession().getServletContext().getRealPath("/resources/images/profile/");
		new File(realPath+vo.getProfile()).delete();
		memberDAO.profileDefault(vo.getMid());
		session.removeAttribute("sProfileImg");
		session.setAttribute("sProfileImg","default.jpg");
	}
	
	@Override
	public int cpIntroImgDelete(String imgName, HttpServletRequest request, String mid) {
		CompanyVO cpVO = createDAO.getCpIdCheck(mid);
		CompanyImgVO cpImgVO = companyDAO.getCpImgInfo(cpVO.getIdx());
		String cpIntroImg = cpImgVO.getCpIntroImg();
		
		cpIntroImg = cpIntroImg.replace(imgName, "");
		if(cpIntroImg.contains("//")) cpIntroImg = cpIntroImg.replace("//", "/");
		else if(cpIntroImg.indexOf("/") == 0) cpIntroImg = cpIntroImg.substring(1);
		else if(cpIntroImg.lastIndexOf("/") == (cpIntroImg.length()-1)) cpIntroImg = cpIntroImg.substring(0,cpIntroImg.length()-1);
		cpImgVO.setCpIntroImg(cpIntroImg);
		
		String realPath = request.getSession().getServletContext().getRealPath("/resources/images/cpIntro/");
		String pathFile = realPath + imgName.split(":")[0];
		new File(pathFile).delete();
		
		return companyDAO.setSaveCpImg(cpImgVO);
	}

	@Override
	public void getCompnayList(PageVO pageVO, Model model, String[] categoriWord, String orderBy, String order,
			String searchItem, String searching) {
		if(orderBy.equals("")) orderBy = "createDayCP";
		if(order.equals("")) order = "desc";
		
		ObjectMapper objectMapper = new ObjectMapper();
		List<CompanyVO> vos = new ArrayList<CompanyVO>();
		List<HashMap<String, Object>> listMap = null;
		
		
		if(searchItem.equals("all") && !searching.equals("")) 
			searching = "(cpName like '%"+searching+"%' or name like '%"+searching+"%' or cpIntro like '%"+searching+"%') ";
		else if(!searching.equals("")) searching = "(" + searchItem + " like '%" +searching+ "%')";
		
		String select = "*";
		String group_by = "";
		String tableName = "company";
		String feildName = "cpExp";
		String feildWord = "";
		String other = " and act = 'on' ";
		if(orderBy.equals("rating")) {
			select = "c.*,ifnull(avg(r.rating),0) as starAvg";
			tableName = "company c left join reply r on concat('c',c.idx) = r.boardidx";
			group_by = "group by c.idx";
			orderBy = "starAvg";
		}
		else if(orderBy.equals("reviewCnt")) {
			select = "c.*";
			tableName = "company c left join reply r on concat('c',c.idx) = r.boardidx";
			group_by = "group by c.idx";
			orderBy = "count(r.idx)";
		}
		
		if(categoriWord == null) {
			listMap = searching.equals("") ? 
				pageProcess.paging(pageVO, model, tableName, feildName, feildWord, orderBy, order, select, group_by, other) :
				pageProcess.paging_Search(pageVO, model, tableName, feildName, feildWord, orderBy, order, searchItem, searching, select, group_by, other);
		}
		else if(categoriWord.length == 1) {
			feildWord = categoriWord[0];
			listMap = searching.equals("") ? 
				pageProcess.paging(pageVO, model, tableName, feildName, feildWord, orderBy, order, select, group_by, other) :
				pageProcess.paging_Search(pageVO, model, tableName, feildName, feildWord, orderBy, order, searchItem, searching, select, group_by, other);
		}
		else {
			for(String word : categoriWord) feildWord += word + "|";
			feildWord = feildWord.substring(0, feildWord.length()-1);
			listMap = searching.equals("") ? 
				pageProcess.pagingManyWords(pageVO, model, tableName, feildName, feildWord, orderBy, order, select, group_by, other) :
			 	pageProcess.pagingManyWords_Search(pageVO, model, tableName, feildName, feildWord, orderBy, order, searchItem, searching, select, group_by, other);
		}
		
		if(listMap.isEmpty()) return;
		
		String star_WHERE = "";
		String star_FIND_IN_SET = "'";
		for(int i=0; i<listMap.size(); i++) {
			vos.add(objectMapper.convertValue(listMap.get(i), CompanyVO.class));
			// 별점 조회
			star_WHERE += "'"+vos.get(i).getIdx()+"',";
			star_FIND_IN_SET += vos.get(i).getIdx()+",";
		}
		if(star_WHERE.length() > 0) {
			star_WHERE = star_WHERE.substring(0,star_WHERE.length()-1);
			star_FIND_IN_SET = star_FIND_IN_SET.substring(0,star_FIND_IN_SET.length()-1) + "'";
		}
		
		String[] strStars = replyDAO.getStarList(star_WHERE,star_FIND_IN_SET);
		double[] starAvgs = new double[strStars.length];
		
		
		for(int i=0; i<strStars.length; i++) {
			String[] stars = strStars[i].split(",");
			if(stars.length == 1) {
				starAvgs[i] = Double.parseDouble(stars[0]);
				continue;
			}
			double starSum = 0;
			int count = 0;
			for(String star : stars) {
				if(star.equals("0")) continue;
				starSum += Double.parseDouble(star);
				count++;
			}
			if(count == 0) starAvgs[i] = 0.0;
			else starAvgs[i] = starSum / count;
		}
		
		for(int i=0; i<starAvgs.length; i++) vos.get(i).setStarAvg(starAvgs[i]);
		
		model.addAttribute("vos",vos);
		String strImgSearch = "";
		for(int i=0; i<vos.size(); i++) strImgSearch += vos.get(i).getIdx() + ",";
		if(strImgSearch.length() > 0) {
			strImgSearch = strImgSearch.substring(0, strImgSearch.length()-1);
			List<CompanyImgVO> imgVOS = memberDAO.getCompanyImgList(strImgSearch);
			model.addAttribute("imgVOS",imgVOS);
		}
		
	}

	@Override
	public List<ReplyVO> getReplyList(String boardIdx, int start, int end) {
		List<ReplyVO> vos = replyDAO.getReplyList(boardIdx,start,end);
		if(vos.size() > 0) {
			for(ReplyVO vo : vos) {
				String mid = vo.getMid();
				vo.setMid(mid.substring(0,2)+"***"+mid.substring(6));
				vo.setOriMid(mid);
			}
		}
		return vos;
	}

	@Override
	public int getReplyTot(String boardIdx) {
		return replyDAO.getReplyTot(boardIdx);
	}

	@Override
	public List<PointVO> getPointInfo(String mid) {
		return pointDAO.getPointInfo(mid);
	}

	@Override
	public int updateUserInfo(UserVO vo) {
		return memberDAO.updateUserInfo(vo);
	}

	@Override
	public int updateUserPwd(String mid, String newPwd) {
		return memberDAO.updateUserPwd(mid,newPwd);
	}

	@Override
	public List<HelpVO> getHelpList(String mid) {
		return memberDAO.getHelpList(mid);
	}

	@Override
	public int helpInput(HelpVO vo, String mid) {
		return memberDAO.helpInput(vo,mid);
	}

	@Override
	public void cpViewCntUpdate(int idx) {
		memberDAO.cpViewCntUpdate(idx);
	}

	@Override
	public void myInfoDelete(String mid) {
		memberDAO.myInfoDelete(mid);
	}

}
