--====================================================================================================
--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG TONGHOP_BSC_KPI
--====================================================================================================
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Tỷ lệ chạm khách hàng (Dịch vụ CA-IVAN và Tên miền)';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001';
--=====
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001'; --4 cv, 1 nv, 2 gd, 3 pgd, 1 truong line, 2 to truong

Select * From ttkd_bsc.nhanvien
where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD'                   -- 437 record
      and ma_vtcv in (Select ma_vtcv from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001');

--=== KIEM TRA VTCV THEO MA_KPI - KIỂM TRA ĐẠ ĐỦ VỊ TRÍ CV NHƯ THEO VB HAY CHƯA
Select * From TTKD_BSC.blkpi_dm_to_pgd@ttkddb where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001'; --and ma_pb = 'VNP0703000';

--=== FILE KQ
Select * From khanhtdt_ttkd.TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001' Order by LOAI;

--====================================================================================================--
--===== CẬP NHẬT BÀNG TONGHOP_BSC_KPI - MA_KPI = HCM_TL_CSKH_001
--====================================================================================================--
Select * From ttkd_bsc.bangluong_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001'; -- 416 record

--=====
Update ttkd_bsc.bangluong_kpi a
	Set a.GIAO = null, a.THUCHIEN = null, a.TYLE_THUCHIEN = null, a.DIEM_CONG = 0, a.DIEM_TRU = 0
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_TL_CSKH_001'
	  and exists (  Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                    Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                          and ma_kpi = 'HCM_TL_CSKH_001'
                          and a.ma_vtcv = ma_vtcv
                 );
Commit;
--===== NHÂN VIÊN
Update ttkd_bsc.bangluong_kpi a
	Set (a.GIAO, a.THUCHIEN)
		= ( 
			Select distinct so_giao, so_thuchien
			From khanhtdt_ttkd.TONGHOP_BSC_KPI_2024
			where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
					and ma_kpi = 'HCM_TL_CSKH_001'
					and loai = 1
					and a.ma_nv = ma_nv
		  )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_TL_CSKH_001'
	  and exists (  Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                    Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                          and ma_kpi = 'HCM_TL_CSKH_001'
						  and GIAMDOC_PHOGIAMDOC is null
                          and a.ma_vtcv = ma_vtcv
                 );
Commit;
--===== TỔ TRƯỞNG
Update ttkd_bsc.bangluong_kpi a
	Set (a.GIAO, a.THUCHIEN)
		= ( 
			Select distinct so_giao, so_thuchien
			From khanhtdt_ttkd.TONGHOP_BSC_KPI_2024
			where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
					and ma_kpi = 'HCM_TL_CSKH_001'
					and loai = 2
					and a.ma_nv = ma_nv
		  )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_TL_CSKH_001'
	  and exists (  Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                    Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                          and ma_kpi = 'HCM_TL_CSKH_001'
						  and TO_TRUONG_PHO = 1
                          and a.ma_vtcv = ma_vtcv
                 );
Commit;
--===== PHÓ GIÁM ĐỐC
Update ttkd_bsc.bangluong_kpi a
	Set (a.GIAO, a.THUCHIEN)
		= ( 
			Select distinct so_giao, so_thuchien
			From khanhtdt_ttkd.TONGHOP_BSC_KPI_2024
			where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
					and ma_kpi = 'HCM_TL_CSKH_001'
					and loai = 3
					and a.ma_nv = ma_nv
		  )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_TL_CSKH_001'
	  and exists (  Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                    Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                          and ma_kpi = 'HCM_TL_CSKH_001'
						  and GIAMDOC_PHOGIAMDOC = 1
                          and a.ma_vtcv = ma_vtcv
                 );
Commit;

--===== TỶ LỆ THỰC HIỆN
Update ttkd_bsc.bangluong_kpi a
	Set a.TYLE_THUCHIEN = Round( a.THUCHIEN*100/a.GIAO,2 )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_TL_CSKH_001'
	  and exists (  Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                    Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                          and ma_kpi = 'HCM_TL_CSKH_001'
                          and a.ma_vtcv = ma_vtcv
                 );
Commit;
--===== ĐIỂM CỘNG TRỪ
Update ttkd_bsc.bangluong_kpi a
	Set a.DIEM_TRU = (Case when a.TYLE_THUCHIEN >= 95 and a.TYLE_THUCHIEN < 100 then 2
                           when a.TYLE_THUCHIEN < 95 then 4
                      else 0
                      end)
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_TL_CSKH_001'
	  and exists (  Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                    Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                          and ma_kpi = 'HCM_TL_CSKH_001'
                          and a.ma_vtcv = ma_vtcv
                 );
Commit;
--=====
Select * From ttkd_bsc.bangluong_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001' and THUCHIEN is not null Order by ten_pb, ten_vtcv; -- 416 record
Select * From ttkd_bsc.bangluong_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001' and DIEM_TRU > 0;
--===== TEST NGẪU NHIÊN 1 nv - 1 pgd
Select * From ttkd_bsc.bangluong_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001' and THUCHIEN is not null Order by ten_pb, ten_vtcv;
Select ma_nv, so_giao, so_thuchien From khanhtdt_ttkd.tonghop_bsc_kpi_2024 where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001' and ma_nv = 'VNP017462'; -- test nv
Select ma_nv, so_giao, so_thuchien From khanhtdt_ttkd.tonghop_bsc_kpi_2024 where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001' and ma_nv = 'VNP017721'; -- test ldp
