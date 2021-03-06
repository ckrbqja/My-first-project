package com.rent.controller;

import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.mysql.cj.jdbc.SuspendableXAConnection;
import com.rent.domain.BuyVO;
import com.rent.domain.CarVO;
import com.rent.domain.BuyVO;
import com.rent.domain.CounselingVO;
import com.rent.domain.MemberVO;
import com.rent.domain.OptionCarVO;
import com.rent.domain.PagingVO;
import com.rent.domain.PreferenceVO;
import com.rent.domain.RentListVO;
import com.rent.domain.RentVO;
import com.rent.domain.ShortRentVO;
import com.rent.service.BuyService;
import com.rent.service.CarColorService;
import com.rent.service.CarOptionService;
import com.rent.service.CarService;
import com.rent.service.CounselingService;
import com.rent.service.MemberService;
import com.rent.service.RentImageService;
import com.rent.service.RentService;
import com.rent.service.ShortRentService;

@Controller
@RequestMapping("/counseling")
public class CounselingController {
	
	@Resource(name="com.rent.service.MemberService")
	MemberService mMemberService;	
	

	@Resource(name="com.rent.service.RentImageService")
	RentImageService rentImageService;
	
	@Resource(name = "com.rent.service.CarColorService")
	CarColorService colorService;
	
	@Resource(name="com.rent.service.CounselingService")
	CounselingService couService;
	
	@Resource(name="com.rent.service.RentService")
	RentService rentService;
	
	@Resource(name = "com.rent.service.CarService")
	CarService carService;
	
	@Resource(name="com.rent.service.CarOptionService")
	CarOptionService optService;

	@Resource(name="com.rent.service.ShortRentService")
	ShortRentService shortService;
	@Resource(name="com.rent.service.BuyService")
	BuyService buyService;
	
	/**
	 * 상담 등록페이지
	 * @param model
	 * @param request
	 * @param rent_id
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/insert/{rent_id}")
	public String counselingSend(Model model, HttpServletRequest request, @PathVariable String rent_id) throws Exception{
		
		String id = request.getParameter("id");
		
		if(id != "") {
			MemberVO member = mMemberService.memberDetail(id);
			String address[] = member.getAddress().split("/");
			model.addAttribute("address",address);
			model.addAttribute("member" ,member);
		}
		
		String totalPrice = request.getParameter("totalPrice"); // 총합 비용
		String deposit = request.getParameter("deposit"); //보증금
		String month = request.getParameter("term"); // 계약날짜

		model.addAttribute("month", month);
		model.addAttribute("totalPrice", totalPrice);
		model.addAttribute("deposit", deposit);
		
		RentVO rent = rentService.rentDetail(rent_id);
		//rent에서 car_id뽑아낸다.
		int car_id = rent.getCar_id();
		
		model.addAttribute("car", carService.carDetail(Integer.toString(car_id)));
		model.addAttribute("rent", rent);
		
		return "/counseling/counselingInsert";
	}
	/**
	 * 상담 등록 프로세스
	 * @param counseling
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/insertProc")
	private String counselingInsert(CounselingVO counseling, HttpServletRequest request) throws Exception{
		
		String rent_id = request.getParameter("rent_id");
		String zipcode = request.getParameter("address0");
		String address1 = request.getParameter("address1");
		String address2 = request.getParameter("address2");
		String address = zipcode+"/"+address1+"/"+address2;
		
		counseling.setAddress(address);
		
		List<OptionCarVO> optionList = optService.optionDetail(rent_id);
		//rent_id에 해당하는 option_name들을 합친다.
		String options = "";
		for(int i =0; i< optionList.size(); i++) {
			options += optionList.get(i).getOption_name();
			if(optionList.size() > i+1) options+=", ";	
		}
		//회원이면 아이디값 , 비회원이면 비회원 넣기
		String id = request.getParameter("id");
		if(id == "") {
			counseling.setId("비회원");
		}
		
		counseling.setOption_name(options);
		counseling.setCounseling_situation("상담 대기중");
		couService.counselingInsert(counseling);
		
		RentVO rent = rentService.rentDetail(rent_id);
		//상담한 차에 상담대기인원수 증가시키기
		int standby = rent.getStandby_personnel();
		rent.setStandby_personnel(standby+1);
		rent.setSituation("상담중");
		rentService.rentStandby(rent);
		
		return "redirect:/rent/rentList";
	}
	
	/**
	 * 상담 전체 목록
	 * @param model
	 * @param paging
	 * @param nowPage
	 * @param cntPerPage
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list")
	public String counselingList(Model model, PagingVO paging
			, @RequestParam(value="nowPage", required=false)String nowPage
			, @RequestParam(value="cntPerPage", required=false)String cntPerPage) throws Exception {
		
		int total = couService.counselingCount();
		if (nowPage == null && cntPerPage == null) {
			nowPage = "1";
			cntPerPage = "5";
		} else if (nowPage == null) {
			nowPage = "1";
		} else if (cntPerPage == null) { 
			cntPerPage = "5";
		}
		
		paging = new PagingVO(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage));
		System.out.println("Controller페이지당 글 갯수 "+paging.getCntPerPage());
		
		List<CounselingVO> cou = couService.counselingList(paging);
		List<String> car_name = new ArrayList<String>();
		System.out.println("couList : "+cou);
		System.out.println("cou.size : "+cou.size());
		for(int i = 0; i < cou.size(); i++) {
			String rent_id = cou.get(i).getRent_id();
			
			if(rent_id == null) {
				car_name.add("선택차량없음");
				System.out.println("if문들어온 차량 : "+car_name);
				continue;
			}
			System.out.println("차량 이름 : "+car_name);
			RentVO ren = rentService.rentListId(rent_id);
			int car_id = ren.getCar_id();
			CarVO car = carService.carDetail(Integer.toString(car_id));
			car_name.add(car.getCar_name());
		}
		
		model.addAttribute("car",car_name);
		model.addAttribute("paging", paging);
		model.addAttribute("counselingList",couService.counselingList(paging));
		return "/counseling/counselingList";
	}
	
	/**
	 * 전체목록(조건검색)
	 * @param counseling_situation
	 * @param model
	 * @param paging
	 * @param nowPage
	 * @param cntPerPage
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/searchList/{counseling_situation}")
	public String searchList(@PathVariable String counseling_situation, Model model, PagingVO paging
			, @RequestParam(value="nowPage", required=false)String nowPage
			, @RequestParam(value="cntPerPage", required=false)String cntPerPage) throws Exception {
		
		int total = couService.searchListCount(counseling_situation);
		if (nowPage == null && cntPerPage == null) {
			nowPage = "1";
			cntPerPage = "5";
		} else if (nowPage == null) {
			nowPage = "1";
		} else if (cntPerPage == null) { 
			cntPerPage = "5";
		}
		
		paging = new PagingVO(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage));
		paging.calcStartEnd(Integer.parseInt(nowPage), Integer.parseInt(cntPerPage));
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("counseling_situation", counseling_situation);
		map.put("start", paging.getStart());
		map.put("end", paging.getEnd());
		
		List<CounselingVO> cou = couService.counselingList(paging);
		List<String> car_name = new ArrayList<String>();
		System.out.println("couList : "+cou);
		System.out.println("cou.size : "+cou.size());
		for(int i = 0; i < cou.size(); i++) {
			String rent_id = cou.get(i).getRent_id();
			
			if(rent_id == null) {
				car_name.add("선택차량없음");
				System.out.println("if문들어온 차량 : "+car_name);
				continue;
			}
			System.out.println("차량 이름 : "+car_name);
			RentVO ren = rentService.rentListId(rent_id);
			int car_id = ren.getCar_id();
			CarVO car = carService.carDetail(Integer.toString(car_id));
			car_name.add(car.getCar_name());
		}
		
		model.addAttribute("car",car_name);
		model.addAttribute("paging", paging);
		model.addAttribute("counselingList", couService.searchList(map));
		return "/counseling/counselingList";
	}
	
	/**
	 * 상담글 상세보기
	 * @param counseling_id
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/detail/{counseling_id}")
	public String counselingDetail(@PathVariable String counseling_id, Model model) throws Exception {
		CounselingVO cou = couService.counselingDetail(counseling_id);
		String rent_id = cou.getRent_id();
		
		if(rent_id == null) {
			
		}else {
			RentVO rent = rentService.rentDetail(rent_id);
			int car_id = rent.getCar_id();
			CarVO car = carService.carDetail(Integer.toString(car_id));
			model.addAttribute("car", car);
		}
		
		model.addAttribute("detail", couService.counselingDetail(counseling_id));
		return "/counseling/counselingDetail";
	}
	
	/**
	 * 상담글 상태 현황 변경(상담완료, 예약완료)
	 * @param counseling
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/update")
	public String counselingUpdate(CounselingVO counseling, HttpServletRequest request) throws Exception {
		String counseling_id = request.getParameter("counseling_id");
		String rent_id = request.getParameter("rent_id_"+counseling_id);
		RentVO rent = rentService.rentDetail(rent_id);
		couService.counselingUpdate(counseling);
		
		String counseling_situation = request.getParameter("counseling_situation");
		if(counseling_situation.equals("예약완료")) {
			//예약완료면 rent테이블 렌트완료, car테이블 car_number -1 하기
			String id = Integer.toString( rent.getCar_id());
			CarVO car = carService.carDetail(id);
			int car_count= car.getCar_number();
			car_count -=1;
			if(car_count == -1) car_count = 0; //혹시 모르니 만듬
			car.setCar_number(car_count);
			
			carService.carNumberAdding(car);
			System.out.println("예약완료");
		}else if(counseling_situation.equals("상담완료")) {
			
			int standby = rent.getStandby_personnel();
			//standby가 1일경우 상담인원이 0명이 됨 그래서 예약가능으로 바꾸기
			if(standby == 1 ) rent.setSituation("예약가능");
			
			//상담완료면 렌트테이블 상담인원 -1
			rent.setStandby_personnel(standby-1);
			
			rentService.rentStandby(rent);
			System.out.println("상담완료");
		}
		
		return "redirect:/counseling/detail/"+counseling_id;
	}
	
	/**
	 * 상담글 삭제
	 * @param counseling_id
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delete/{counseling_id}")
	public String counselingDelete(@PathVariable String counseling_id, HttpServletRequest request) throws Exception {
		
		///고객센터에서 상담신청 했을경우 rent_id가 없다.
		if(request.getParameter("rent_id_"+counseling_id) == "") {
			couService.counselingDelete(counseling_id);
			return "redirect:/counseling/list";
		}
		
		String rent_id = request.getParameter("rent_id_"+counseling_id);
		RentVO rent = rentService.rentDetail(rent_id);
		
		System.out.println(rent_id);
		
		//상담한 차에 상담대기인원수 1빼기
		int standby = rent.getStandby_personnel();
		
		if(standby == 1) {
			System.out.println("standby==1 : "+standby);
			rent.setStandby_personnel(standby-1);
			rent.setSituation("예약가능");
		}else if(standby == 0) { //혹시 모르니 만들어둠
			System.out.println("standby==0 : "+standby);
			rent.setStandby_personnel(0);
			rent.setSituation("예약가능");
		}else {
			System.out.println("ELSE: standby : "+standby);
			rent.setStandby_personnel(standby-1);
		}
		
		rentService.rentStandby(rent);
		couService.counselingDelete(counseling_id);
		
		return "redirect:/counseling/list";
	}
	
	@RequestMapping("/mainProc")
	public String mainProc(HttpServletRequest request, Model model, HttpSession session) throws Exception{
		String id = (String)(session.getAttribute("id"));
		if(id != null) {
		MemberVO list = mMemberService.accountDetail(id);
		String [] address = list.getAddress().split("/");
		String [] tel = list.getTel().split("\\|");
		String [] date = list.getDate_of_birth().split("-");
		list.setDate_of_birth(date[0]+date[1]+date[2]);
		
		model.addAttribute("address", address);
		model.addAttribute("tel", tel);
		model.addAttribute("detail", list);
		}
		model.addAttribute("sD",request.getParameter("startDate"));
		model.addAttribute("sH",request.getParameter("sHour"));
		model.addAttribute("sM",request.getParameter("sMinute"));
		model.addAttribute("sL",request.getParameter("sLocation"));
		model.addAttribute("eD",request.getParameter("endDate"));
		model.addAttribute("lH",request.getParameter("lHour"));
		model.addAttribute("lM",request.getParameter("lMinute"));
		model.addAttribute("lL",request.getParameter("lLocation"));
		model.addAttribute("carKind",request.getParameter("carKind"));
		model.addAttribute("location", rentService.location());
		return "/counseling/short_rent";
	}
	
	@RequestMapping("/short_rent")
	public String short_rent(Model model, HttpSession session, @RequestParam(defaultValue = "서울지점") String sL) throws Exception{
		String id = (String)(session.getAttribute("id"));
		if(id != null) {
		MemberVO list = mMemberService.accountDetail(id);
		String [] address = list.getAddress().split("/");
		String [] tel = list.getTel().split("\\|");
		
		model.addAttribute("address", address);
		model.addAttribute("tel", tel);
		model.addAttribute("detail", list);
		}
		model.addAttribute("location", rentService.location());
		model.addAttribute("sL",sL);
		return "/counseling/short_rent";
	}
	
	@RequestMapping("/short_rentProc")
	public String short_rentProc(BuyVO buy, Model model, HttpSession session, HttpServletRequest request) throws Exception{
		String id = (String)(session.getAttribute("id"));
		buy.setId(id);
		buy.setColor(rentService.rentDetail(request.getParameter("rent_id")).getColor());
		buy.setRent_id(request.getParameter("rent_id"));
		buy.setOption_name("null");
		buy.setMonth("null");
		buy.setAddress(request.getParameter("zipCode")+"/"+request.getParameter("address")+"/"+request.getParameter("addressDetail"));
		
		return "/counseling/short_rent";
	}
	
	@RequestMapping("/short_rentDetail")
	@ResponseBody
	public Map<String, Object> short_rentDetail(Model model, HttpSession session, HttpServletRequest request) throws Exception{
		String [] carKind = {"소형", "중형", "준중형", "대형", "RV", "친환경차"};
		RentVO rent = new RentVO();
		rent.setLocation(request.getParameter("start_location"));
		List<ShortRentVO> sList = shortService.getTimeList();
		Map<String, Object> map = new HashMap<String, Object>();
		List<String> rent_id = new ArrayList<String>();
try {		
		if(!request.getParameter("start_date").equals("대여일 선택") || !request.getParameter("end_date").equals("반납일 선택") ) {
			Date start_date = Date.valueOf(request.getParameter("start_date"));
			Date end_date   = Date.valueOf(request.getParameter("end_date"));
			int sHour = Integer.parseInt(request.getParameter("sHour"))+1;
			int lHour = Integer.parseInt(request.getParameter("lHour"))+1;

			for(ShortRentVO sho : sList) {
				boolean cnt  = false;
				System.out.println(sho.getEnd_date().compareTo(start_date) + "  "  + sho.getStart_date().compareTo(end_date) );
				if(sho.getEnd_date().compareTo(start_date) == -1  ||  sho.getStart_date().compareTo(end_date) == 1)
					cnt = true;
					
				if(sho.getEnd_date().compareTo(start_date) == 0)
					if(Integer.parseInt(sho.getEnd_time().substring(0,2)) < sHour)
						cnt = true;

				if(sho.getStart_date().compareTo(end_date) == 0)
					if(Integer.parseInt(sho.getStart_time().substring(0,2)) > lHour)
						cnt = true;
				
				if(cnt) rent_id.add(Integer.toString(sho.getRent_id()));
			}
			
		}//end - if(!request.getParameter("start_date").equals("대여일 선택") || !request.getParameter("end_date").equals("반납일 선택") )
		
		
		System.out.println("rent  " + rent_id);
		for(int i = 0; i < 7; i ++) {
			rent.setCar_id(i);
			List<CarVO> carList = rentService.carKindList(rent);
			List<CarVO> car = new ArrayList<CarVO>();
			for(CarVO cv : carList) {
				if(sList != null) {
					for(ShortRentVO sv : sList) {
						 if(sv.getRent_id() == cv.getRent_id()) {
							 cv.setSituation("X");
								if(!rent_id.isEmpty()) {
									for(String rt : rent_id) {
										if(Integer.parseInt(rt) == cv.getRent_id()) {
											cv.setSituation("예약가능");
											break;
										}
									}//end - for(String rt : rent_id)
								}
						 }
					}//end - for(ShortRentVO sv : sList)
				}
				car.add(cv);
			}// end - for(CarVO cv : carList)
			map.put("a"+i,car);
		}
}catch (Exception e) {
	System.out.println("null무시");
}


		
		map.put("rent_id", rent_id);
		map.put("carKind",  carKind);
		map.put("short", sList);
		return map;
	}
	
	@RequestMapping("/newRent")
	public String newRent(CounselingVO list, HttpSession session) throws Exception{
		list.setId((String)session.getAttribute("id"));
		if(session.getAttribute("id")==null || session.getAttribute("id").equals("")) list.setId("비회원");
		list.setOption_name("파퓰러 패키지,빌트인 캠 패키지");
		list.setCounseling_situation("상담 대기중");
		couService.counselingInsert(list);
		return "redirect:/counseling/userList?tel="+list.getTel();
	}
	
	@RequestMapping("/userList")
	public String userList(Model model, HttpSession session, @RequestParam(defaultValue = "n")String tel)throws Exception{
		List<CounselingVO> list = new ArrayList<CounselingVO>();
		if(tel.equals("n"))
			list = couService.counselingListId((String)session.getAttribute("id"));
		else
			list = couService.counselingListTel(tel);
		List<String> carName = new ArrayList<String>();
		for(CounselingVO List : list) {
			carName.add(carService.carName(rentService.carName(List.getRent_id())));
		}
		if(list.isEmpty())
			model.addAttribute("tel", tel);
		else
			model.addAttribute("tel", list.get(0).getTel());
		List<String> map = new ArrayList<String>();
		//렌트가 신찬지 아닌지 조회
		for(int i = 0; i < list.size(); i++) {
			CounselingVO List = list.get(i);
			if(List.getRent_id() != null) {
			if(rentService.rentDetail(List.getRent_id()).getSpecial_note() != null)
				map.add(rentService.rentDetail(List.getRent_id()).getSpecial_note());
			if(rentService.rentDetail(List.getRent_id()).getSpecial_note() == null)
				map.add("null");
			}
				
		}
		model.addAttribute("map", map);
		model.addAttribute("couList", list);		
		model.addAttribute("carName", carName);		
		return "/counseling/userList";
	}
	
	/**
	 * 고객센터->상담신청  등록해준다
	 * @param rq
	 * @param counseling
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/asInsertProc")
	public String asConsultationInsert(HttpServletRequest rq, CounselingVO counseling) throws Exception {
		String zipcode = rq.getParameter("address0");
		String address1 = rq.getParameter("address1");
		String address2 = rq.getParameter("address2");
		
		String carType = rq.getParameter("carType");
		String contents1 = rq.getParameter("contents1");
		String contents2 = rq.getParameter("contents2");
		String contents3 = rq.getParameter("contents3");
		
		String address = zipcode+"/"+address1+"/"+address2;
		String option_name = "선택차종 : " + carType + "<br>" +
		"희망차량 : " + contents1 + "<br>"+
		"희망옵션 : " + contents2 + "<br>"+
		"문의내용 : " + contents3;
				
		counseling.setAddress(address);
		counseling.setOption_name(option_name);
		counseling.setCounseling_situation("상담 대기중");
		
		//회원이면 아이디값 , 비회원이면 비회원 넣기
		String id = rq.getParameter("id");
		if(id == "") {
			counseling.setId("비회원");
		}
		
		couService.counselingInsert(counseling);
		return "/main";
	}
	
	@RequestMapping("/userListDetail/{rent_id}")
	public String userListDetail(@PathVariable String rent_id, Model model ,@RequestParam String cou_id)throws Exception{
		RentVO rent = new RentVO();
		rent = rentService.rentDetail(rent_id);
		
		String onOff[] = new String [8]; 
		for(int i = 0; i < 8; i++) {
			onOff[i] = "off";
		}
		List<OptionCarVO> list = optService.optionDetail(rent_id);
		System.out.println(list);
		for(int i = 0; list.size() > i ; i++) {
			OptionCarVO List = list.get(i);
			
			if(List.getOption_name().equals("가죽시트")) 	onOff[0] = "on";
			if(List.getOption_name().equals("네비게이션")) 	onOff[1] = "on";
			if(List.getOption_name().equals("ECM룸미러")) 	onOff[2] = "on";
			if(List.getOption_name().equals("스마트키")) 	onOff[3] = "on";
			if(List.getOption_name().equals("썬루프")) 		onOff[4] = "on";
			if(List.getOption_name().equals("통풍시트")) 	onOff[5] = "on";
			if(List.getOption_name().equals("후방카메라")) 	onOff[6] = "on";
		}
		model.addAttribute("rent"   	, rent);
		model.addAttribute("car"    	, carService.carDetail(Integer.toString(rent.getCar_id())));
		model.addAttribute("rentImage" 	, rentImageService.imageList(Integer.parseInt(rent_id)));
		model.addAttribute("oList"  	, list);
		model.addAttribute("count"  	, onOff);
		model.addAttribute("month"  	, couService.counselingDetail(cou_id).getMonth());
		PreferenceVO preference = new PreferenceVO();
		List<BuyVO> buyIdList = new ArrayList<BuyVO>();
		buyIdList = buyService.buyListMember(rent_id); //id가져옴
		for(int i=0; i < buyIdList.size(); i++) {
			String id = buyIdList.get(i).getId();
			//성별
			String gender = buyService.memberInformation(id).getGender();
			//나이   mysql에서 소수점 제거해도 소수점 나옴 ;;
			int age = Integer.parseInt(buyService.memberInformation(id).getDate_of_birth().substring(0, 2));

			System.out.println("======================================");
			//id에 해당하는 성별을 추출해서 preferenceVO에 해당 정보에 1씩 더한다 (성별)
			if(gender.equals("남자")) {
				preference.setMan(preference.getMan()+1);
				System.out.println("pre Man : "+preference.getMan());;
			}else {
				preference.setWomen(preference.getWomen()+1);
				System.out.println("pre Women : "+preference.getWomen());
			}
			//id에 해당하는 정보를 추출해서 preferenceVO에 해당 정보에 1씩 더한다 (나이)
			if(age >=60) {
				preference.setSixties(preference.getSixties()+1);
				System.out.println("60대 "+age);
			}else if(age >=50) {
				preference.setFifteen(preference.getFifteen()+1);
				System.out.println("50대 "+age);
			}else if(age >=40) {
				preference.setForties(preference.getForties()+1);
				System.out.println("40대 "+age);
			}else if(age >=30) {
				preference.setThirties(preference.getThirties()+1);
				System.out.println("30대 "+age);
			}else if(age >=20) {
				preference.setTwenties(preference.getTwenties()+1);
				System.out.println("20대 "+age);
			}else{
				System.out.println("나가");
			}
			//정보를 추출했으니 총인원수에 +1한다.
			preference.setTotal(preference.getTotal()+1);
			
			System.out.println("아이디 : "+id);
			System.out.println("나이 : "+ age);
			System.out.println("성별 : "+ gender);
			System.out.println();
			
		}
		System.out.println("남자 : "+preference.getMan());
		System.out.println("여자 : "+preference.getWomen());
		System.out.println("총인원수 : "+preference.getTotal());
		System.out.println("20대수 : "+preference.getTwenties());
		System.out.println("30대수 : "+preference.getThirties());
		System.out.println("40대수 : "+preference.getForties());
		System.out.println("50대수 : "+preference.getFifteen());
		System.out.println("60대수 : "+preference.getSixties());
		System.out.println("buyIdList.size() : "+ buyIdList.size());
		int percent;
		//차를 구매했던 사람이 없으면 0값을 넣어 0을 나누지 못하게한다. 오류방지
		if(buyIdList.size() == 0) {
			percent = 0;
		}else {
			percent = 100 / preference.getTotal();
		}
		
		preference.setMan(percent * preference.getMan());
		preference.setWomen(percent * preference.getWomen());
		preference.setTwenties(percent * preference.getTwenties());
		preference.setThirties(percent * preference.getThirties());
		preference.setForties(percent * preference.getForties());
		preference.setFifteen(percent * preference.getFifteen());
		preference.setSixties(percent * preference.getSixties());
		
		model.addAttribute("preference", preference);
		
		return "/counseling/userListDetail";
	}
	
	
}
