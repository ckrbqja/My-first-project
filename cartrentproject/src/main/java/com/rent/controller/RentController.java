package com.rent.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.security.auth.message.callback.PrivateKeyCallback.Request;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rent.domain.BuyVO;
import com.rent.domain.CarColor;
import com.rent.domain.CarVO;
import com.rent.domain.MemberVO;
import com.rent.domain.OptionCarVO;
import com.rent.domain.PreferenceVO;
import com.rent.domain.RentImageVO;
import com.rent.domain.RentVO;
import com.rent.domain.RentListVO;
import com.rent.service.BuyService;
import com.rent.service.CarColorService;
import com.rent.service.CarOptionService;
import com.rent.service.CarService;
import com.rent.service.MemberService;
import com.rent.service.RentImageService;
import com.rent.service.RentService;

@Controller
@RequestMapping("/rent")
public class RentController {
	@Resource(name="com.rent.service.MemberService")
	MemberService mMemberService;	
	
	@Resource(name = "com.rent.service.CarColorService")
	CarColorService colorService;

	@Resource(name = "com.rent.service.CarService")
	CarService carService;
	
	@Resource(name = "com.rent.service.RentService")
	RentService rentService;
	
	@Resource(name="com.rent.service.RentImageService")
	RentImageService rentImageService;
	
	@Resource(name="com.rent.service.CarOptionService")
	CarOptionService opService;
	
	@Resource(name="com.rent.service.BuyService")
	BuyService buyService;
	
	//렌트목록
	@RequestMapping("/rentList")
	public String rentList(Model model, HttpServletRequest requset) throws Exception {
		//메인.doa에서 받아온 값이 있으면
		if(requset.getParameter("manufacturer") != null) {
		model.addAttribute("ma", requset.getParameter("manufacturer"));
		model.addAttribute("ck", requset.getParameter("carKind"));
		model.addAttribute("cn", requset.getParameter("carName"));
		}
		//제조사 정보 출력을 위한 정보
		model.addAttribute("manufacturer", carService.manufacturer());
		//연료 정보 출력을 위한 정보
		model.addAttribute("fuel", carService.fuel());
		//지역 정보 출력을 위한 정보
		model.addAttribute("location", rentService.location());
		return "/rent/skList";
	}
	
	//제조사 출력 ajax
	@RequestMapping("/carKind")
	@ResponseBody
	public Map<String, Object> carKind(@RequestParam String manufacturer)throws Exception{
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("map", carService.carKind(manufacturer));
		return map;
	}

	//차유형 출력 ajax
	@RequestMapping("/selectCar")
	@ResponseBody
	public Map<String, Object> selectCar(CarVO car)throws Exception{
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("map", carService.selectCar(car));
		return map;
	}
	
	//차 리스트 조건부 출력 ajax
	@RequestMapping("/rentListProc")
	@ResponseBody
	public Map<String, Object> rentListProc(RentListVO list, Model model, HttpServletRequest request)throws Exception{
		List<String> location 	= new ArrayList<String>();
		List<String> fuel 		= new ArrayList<String>();
		//location 정보 5개를 가져온다
			for(int i = 0; i < 5; i ++) {
				if(!request.getParameter("l"+i).equals(""))
				location.add(request.getParameter("l"+i));
				list.setLocation(location);
			}
		//fuel 정보 5개를 가져온다
			for(int i = 0; i < 5; i ++) {
				if(!request.getParameter("f"+i).equals(""))
				fuel.add(request.getParameter("f"+i));
				list.setFuel(fuel);
			}
		
		//조회한 정보 갯수
		int listCount = rentService.rentListPro(list).get(0).getRent_id();
		//보여질 아이템 갯수
		int showCount = 6;
		int temp  = listCount/showCount+1;
		//총 페이지 수 = 전체 수 / 보여질 갯수
		int count = temp;
		System.out.println();
		//더보기 버튼이 처음 눌려지는게 아닐 시 리미트 값을 가져온다
		if(list.getLimit().equals("NaN")) count = 0; 
		else if(list.getLimit() != "") count = Integer.parseInt(list.getLimit());
		//총 페이지 수에서 리미트값을 뺀 값에 보여질 아이템 수를 곱한다
		int Ccount = (temp - count +1) * showCount;
		list.setLimit(Integer.toString(Ccount));
		//정보를 통해 출력할 리스트 값을 가져온다.
		list.setTemp("list");
		List<RentVO> rentList 	 = rentService.rentListPro(list);
		
		
		//보낼 값들을 map에 넣는다
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rentList", rentList);
		map.put("count", count);
		map.put("total", listCount);
		map.put("showCount", showCount);
		return map;
	}
	
	//신차 리스트 조건부 출력 ajax
		@RequestMapping("/newRentListProc")
		@ResponseBody
		public Map<String, Object> newRentListProc(RentListVO list, Model model, HttpServletRequest request)throws Exception{
			
			//조회한 정보 갯수
			int listCount = rentService.newRentListPro(list).get(0).getRent_id();
			//보여질 아이템 갯수
			int showCount = 6;
			int temp  = listCount/showCount+1;
			//총 페이지 수 = 전체 수 / 보여질 갯수
			int count = temp;
			
			//더보기 버튼이 처음 눌려지는게 아닐 시 리미트 값을 가져온다
			if(list.getLimit().equals("NaN")) count = 0; 
			else if(list.getLimit() != "") count = Integer.parseInt(list.getLimit());
			//총 페이지 수에서 리미트값을 뺀 값에 보여질 아이템 수를 곱한다
			int Ccount = (temp - count +1) * showCount;
			list.setLimit(Integer.toString(Ccount));
			//정보를 통해 출력할 리스트 값을 가져온다.
			list.setTemp("list");
			List<RentVO> rentList 	 = rentService.newRentListPro(list);
			
			
			//보낼 값들을 map에 넣는다
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("rentList", rentList);
			map.put("count", count);
			map.put("total", listCount);
			map.put("showCount", showCount);
			return map;
		}
	
	//차량 리스트 상세정보
	@RequestMapping("/rentListDetail/{rent_id}")
	public String rentListDetail(@PathVariable String rent_id, @RequestParam(defaultValue = "1") String mon  ,Model model)throws Exception{
		RentVO rent = new RentVO();
		rent = rentService.rentDetail(rent_id);
		
		String onOff[] = new String [8]; 
		for(int i = 0; i < 8; i++) { onOff[i] = "off"; }
		
		//옵션이 있을 경우 해당 내용을 on으로 바꾼다
		List<OptionCarVO> list = opService.optionDetail(rent_id);
		for(int i = 0; list.size() > i ; i++) {
			OptionCarVO List = list.get(i);
			if(List.getOption_name().equals("ECM룸미러")) onOff[2] = "on";
			if(List.getOption_name().equals("후방카메라")) 	onOff[6] = "on";
			if(List.getOption_name().equals("네비게이션")) 	onOff[1] = "on";
			if(List.getOption_name().equals("가죽시트")) 	onOff[0] = "on";
			if(List.getOption_name().equals("스마트키")) 	onOff[3] = "on";
			if(List.getOption_name().equals("통풍시트")) 	onOff[5] = "on";
			if(List.getOption_name().equals("썬루프")) 	onOff[4] = "on";
		}
		model.addAttribute("rent"   	, rent);
		model.addAttribute("car"    	, carService.carDetail(Integer.toString(rent.getCar_id())));
		model.addAttribute("rentImage" 	, rentImageService.imageList(Integer.parseInt(rent_id)));
		model.addAttribute("oList"  	, list);
		model.addAttribute("count"  	, onOff);
		
		PreferenceVO preference = new PreferenceVO();
		List<BuyVO> buyIdList = new ArrayList<BuyVO>();
		/**
		 * for
		 * 해당 rent_id를 구매했던 사람들의 성별, 나이를 전부 가져와서 평균을 구한다.
		 */
		buyIdList = buyService.buyListMember(rent_id); //id가져옴
		for(int i=0; i < buyIdList.size(); i++) {
			String id = buyIdList.get(i).getId();
			//성별
			String gender = buyService.memberInformation(id).getGender();
			
			
			//나이   mysql에서 소수점 제거해도 소수점 나옴 substring 사용
			int age = Integer.parseInt(buyService.memberInformation(id).getDate_of_birth().substring(0, 2));
			
			//id에 해당하는 성별을 추출해서 preferenceVO에 해당 정보에 1씩 더한다 (성별)
			if(gender.equals("남자"))  	preference.setMan(preference.getMan()+1);
			else  						preference.setWomen(preference.getWomen()+1);
			
			//id에 해당하는 정보를 추출해서 preferenceVO에 해당 정보에 1씩 더한다 (나이)
			if	   (age >=60)  	preference.setSixties (preference.getSixties()+1);
			else if(age >=50)  	preference.setFifteen (preference.getFifteen()+1);
			else if(age >=40)  	preference.setForties (preference.getForties()+1);
			else if(age >=30)  	preference.setThirties(preference.getThirties()+1);
			else if(age >=20)  	preference.setTwenties(preference.getTwenties()+1);
			else 				System.out.println("회원가입 오류");
			
			//정보를 추출했으니 총인원수에 +1한다.
			preference.setTotal(preference.getTotal()+1);
		}
		int percent;
		//차를 구매했던 사람이 없으면 0값을 넣어 0을 나누지 못하게한다. 오류방지
		if		(buyIdList.size() == 0) percent = 0; 
		else 	percent = 100 / preference.getTotal();
		
		preference.setMan		(percent * preference.getMan());
		preference.setWomen		(percent * preference.getWomen());
		preference.setTwenties	(percent * preference.getTwenties());
		preference.setThirties	(percent * preference.getThirties());
		preference.setForties	(percent * preference.getForties());
		preference.setFifteen	(percent * preference.getFifteen());
		preference.setSixties	(percent * preference.getSixties());
			
		model.addAttribute("preference", preference);
		
		//판매 순위 구하기
		//값이 없을경우 오류로인해  String으로 받는다
		String rank  = buyService.getrank(rent_id);
		
		//판매순위 (차량 종류 별)
		//두개의 값을 넘겨야 되므로 맵으로 넘긴다
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rent_id",  rent_id);
		map.put("car_kind", carService.carDetail(Integer.toString(rent.getCar_id())).getCar_kind());
		
		String KRank = buyService.getKindRank(map);
		
		
		//Null이 아닐경우 소수점으로 나눠오기때문에 스플릿으로 나눈다
		if(KRank != null) KRank =  KRank.split("\\.")[0];
		if(rank != null) rank =  rank.split("\\.")[0];
		model.addAttribute("rank", rank);
		model.addAttribute("KRank", KRank);
		model.addAttribute("mon", mon);
		
		return "/rent/rentListDetail";
	}
	
	
	
	
	@RequestMapping("/main.do")
	public String main(Model model) throws Exception{
		String [] carKind = {"차량 선택", "소형", "중형", "준중형", "대형", "RV", "친환경차"};
		model.addAttribute("carKind",  carKind);
		model.addAttribute("location", rentService.location());
		
		return "/rent/main.do";
	}
	
	@RequestMapping("/NewRentList")
	public String NewRentList(Model model) throws Exception{ return "/rent/NewRentList"; }
	
	@RequestMapping("/NewRentListDetail/{rent_id}")
	public String NewRentListDetail(Model model, @PathVariable String rent_id, HttpSession session)throws Exception{		
	String id = (String)(session.getAttribute("id"));
	if(id != null) {
	MemberVO list = mMemberService.accountDetail(id);
	String [] address = list.getAddress().split("/");
	//|는 기호라 앞에 \\을 써야함
	String [] tel = list.getTel().split("\\|");
	String [] date = list.getDate_of_birth().split("-");
	list.setDate_of_birth(date[0]+date[1]+date[2]);
	model.addAttribute("address", address);
	model.addAttribute("tel", tel);
	model.addAttribute("detail", list);
	}
		RentVO rent 	= rentService.rentDetail(rent_id);
		String car_id 	= Integer.toString(rent.getCar_id());
		
		model.addAttribute("rent"	, rent);
		model.addAttribute("car"	, carService.carDetail(car_id));
		model.addAttribute("color"	, colorService.colorDetail(car_id));
		model.addAttribute("option"	, opService.optionDetail(rent_id));
		
		return "/rent/NewRentListDetail";
	}
	
	//색상 AJAX
	@ResponseBody
	@RequestMapping("/rentColorProc")
	public CarColor rentColorProc(Model model, @RequestParam String rent_id, @RequestParam int index)throws Exception{
		RentVO 		rent 	= rentService.rentDetail(rent_id);
		String 		car_id 	= Integer.toString(rent.getCar_id());
		CarColor 	color 	= colorService.colorDetail(car_id).get(index);
		
		color.setColor	(rentService.getPrice(car_id));
		color.setCar_id(Integer.parseInt(rent_id));
		
		return color;
	}
	
	
	
}
