--====================================================================================================
Select * From BSC_TL_CSKH_CA_DOMAIN;
Select ten_ly_do, ten_kq, count(*) From BSC_TL_CSKH_CA_DOMAIN Group by ten_ly_do, ten_kq;
Select ten_kq, count(*) From BSC_TL_CSKH_CA_DOMAIN Group by ten_kq;
--=== Xem loại hình
Select ten_loaihinh, count(*) From BSC_TL_CSKH_CA_DOMAIN Group by ten_loaihinh;
--=== Xem gói cước vì anh Giang thông báo loại gói PS0
Select TOCDO_ID, TEN_GOI_CUOC, count(*) From BSC_TL_CSKH_CA_DOMAIN Group by TOCDO_ID, TEN_GOI_CUOC;
--=== SO sanh MA_NV_GIAO và MA_NV_TH
Select MA_NV_GIAO, MA_NV_TH, (Case when MA_NV_GIAO=MA_NV_TH then 0 else 1 end)SS From BSC_TL_CSKH_CA_DOMAIN Where MA_NV_GIAO is not null;

/* -----------------------------------------------
-- LỌC SỐ LIỆU THEO TIÊU CHUẨN ANH GIANG HƯỚNG DẪN
-- Bỏ: SL_DA_THANHTOANHT VÀ CHUYEN_ONL
-------------------------------------------------- */
Select * From BSC_TL_CSKH_CA_DOMAIN
Where thang_kt = 202502 and SL_DA_THANHTOANHT = 0 and CHUYEN_ONL = 0;

/* TEST SỐ GIAO */
    Select ma_nv_giao, count(*)SL_GIAO From BSC_TL_CSKH_CA_DOMAIN
    Where thang_kt = 202502 and SL_DA_THANHTOANHT = 0 and CHUYEN_ONL = 0
    Group by ma_nv_giao;
/* TEST SO THUC HIEN */
    Select ma_nv_giao, count(*)SL_THUCHIEN From BSC_TL_CSKH_CA_DOMAIN
    Where thang_kt = 202502 and SL_DA_THANHTOANHT = 0 and CHUYEN_ONL = 0
          and (ten_ly_do is not null or ten_kq is not null)
    Group by ma_nv_giao
;

/* ------------------------------------------------------------------
-- Thể hiện trên - ID88
--------------------------------------------------------------------- */
Select *
From (
		Select a.*, nv.ten_nv, nv.ma_vtcv, nv.ten_vtcv, nv.ma_to, nv.ten_to, nv.ma_pb, nv.ten_pb
		From (
				Select THANG_KT THANG, NGAY_KT, TEN_LOAIHINH, THUEBAO_ID, MA_TT, MA_TB, DOMAIN, TEN_TB
					   , TOCDO_ID, TEN_GOI_CUOC, SL_DA_THANHTOANHT, CHUYEN_ONL, NGAY_CN_KQ, TEN_LY_DO, TEN_KQ
					   , MA_NV_GIAO 
				From khanhtdt_ttkd.BSC_TL_CSKH_CA_DOMAIN
				Where thang_kt = 202502 and SL_DA_THANHTOANHT = 0 and CHUYEN_ONL = 0
			 ) a
		Left join ttkd_bsc.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD' and nv.ma_nv = a.ma_nv_giao
	 )
;
