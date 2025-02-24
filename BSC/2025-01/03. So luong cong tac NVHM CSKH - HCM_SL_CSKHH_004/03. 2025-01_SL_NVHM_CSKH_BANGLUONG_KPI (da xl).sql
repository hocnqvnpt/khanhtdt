--===== Muc dich la Insert vào bàng bangluong_kpi
--===== theo VTCV và MA_KPI
-- Số lượng công tác nghiệp vụ,  hậu mãi, CSKH
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Số lượng công tác nghiệp vụ, hậu mãi, CSKH';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_SL_CSKHH_004');
--=== KIEM TRA VTCV THEO MA_KPI - KIỂM TRA ĐẠ ĐỦ VỊ TRÍ CV NHƯ THEO VB HAY CHƯA
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004'; -- => OK đã đủ vị trí như vb 32/2025 (NV CSKH TS P.Onl)
Select * From ttkd_bsc.nhanvien
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD'
      and ma_vtcv in ('VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_16.1','VNP-HNHCM_KDOL_16.2','VNP-HNHCM_KDOL_16.3'); --28 nv tinh_bsc = 1
Select * From ttkd_bsc.bangluong_kpi
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004'; --28 nv: 13 VNP-HNHCM_KDOL_16.1 ; 5 VNP-HNHCM_KDOL_16.2 ; 5 VNP-HNHCM_KDOL_16.3 ; 5 VNP-HNHCM_KDOL_22
--=== KIEM TRA TỔ DO PGD PHỤ TRÁCH - THEO DANH MUC KPI VỊ TRÍ CÔNG VIỆC
--=== Văn bản P.NS tang 08/2024, mã kpi HCM_CL_TNGOI_006 không tính vi trí Tổ trưởng và PGD phụ trách => không cần kiểm tra
Select * From khanhtdt_ttkd.TONGHOP_BSC_KPI_2024
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and MA_KPI = 'HCM_SL_CSKHH_004'
      and ma_vtcv in ('VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_16.1','VNP-HNHCM_KDOL_16.2','VNP-HNHCM_KDOL_16.3') --28 nv tinh_bsc = 1
Order by ma_to, ma_vtcv; --05 nv
--====================================================================================================--
--===== CẬP NHẬT BẢNG LƯƠNG KPI THEO VỊ TRÍ CÔNG VIỆC
--===== Select * From bangluong_kpi where thang = 202409;
--===== MÃ KPI = HCM_SL_CSKHH_004 ==> dành cho nhân viên
--====================================================================================================--
Select * From ttkd_bsc.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and MA_KPI = 'HCM_SL_CSKHH_004' Order by MA_VTCV;
--==========
Update ttkd_bsc.bangluong_kpi a
	Set a.THUCHIEN = null, a.TYLE_THUCHIEN = null, a.MUCDO_HOANTHANH = null
Where a.THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
	  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and MA_KPI in ('HCM_SL_CSKHH_004')						-- <== LƯU Ý MÃ KPI
					      and MA_VTCV = a.MA_VTCV );
Commit;
--========== SỐ LƯỢNG CÁ NHÂN
Update ttkd_bsc.bangluong_kpi a
	set a.THUCHIEN
		= (	
            Select distinct so_thuchien
			From TONGHOP_BSC_KPI_2024
			Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
				  and ma_kpi in ('HCM_SL_CSKHH_004')					-- <== LƯU Ý MÃ KPI
				  and loai = 1
				  and ma_nv = a.ma_nv
		  )
Where a.THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
	  and exists (	
                    Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and MA_KPI in ('HCM_SL_CSKHH_004')						-- <== LƯU Ý MÃ KPI
                          and GIAMDOC_PHOGIAMDOC is null                            -- <= LƯU Ý VỊ TRÍ CA NHAN
					      and MA_VTCV = a.MA_VTCV
                 )
;
Commit;
--========== TY LE THUC HIEN
Update ttkd_bsc.bangluong_kpi a
    Set a.TYLE_THUCHIEN = Round ( (nvl(THUCHIEN,0)*100)/GIAO, 2)
Where a.THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
	  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and MA_KPI in ('HCM_SL_CSKHH_004')						-- <== LƯU Ý MÃ KPI
					      and MA_VTCV = a.MA_VTCV );
Commit;
--========== MUC DO HOAN THANH
Update ttkd_bsc.bangluong_kpi a
    Set a.MUCDO_HOANTHANH
         = (Case when TYLE_THUCHIEN >= 100 then 120
                 when (TYLE_THUCHIEN >= 80 and TYLE_THUCHIEN < 100) then 100+(TYLE_THUCHIEN-80)
                 when TYLE_THUCHIEN < 80 then TYLE_THUCHIEN
            end)
Where a.THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
	  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						  and MA_KPI in ('HCM_SL_CSKHH_004')						-- <== LƯU Ý MÃ KPI
					      and MA_VTCV = a.MA_VTCV );
Commit;
--==== LẤY NGẪU NHIÊN 1 MA_NV ĐỂ TEST
Select THANG, MA_KPI, TEN_PB, TEN_TO, MA_NV, TEN_NV, MA_VTCV, TYTRONG, DONVI_TINH, GIAO, THUCHIEN, TYLE_THUCHIEN, MUCDO_HOANTHANH
From ttkd_bsc.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and MA_KPI = 'HCM_SL_CSKHH_004' and THUCHIEN > 0 Order by ma_vtcv;
Select THANG, MA_PB, MA_TO, MA_NV, TEN_VTCV, THUCHIEN From ttkd_bsc.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and MA_KPI = 'HCM_SL_CSKHH_004' and THUCHIEN > 0 Order by ma_vtcv;
--==== KIỂM TRA NGẪU NHIÊN 1 MA_NV
Select THANG, MA_PB, MA_TO, MA_NV, SO_THUCHIEN From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_SL_CSKHH_004') and loai = 1 and ma_nv in ('CTV082664');
--Select THANG, MA_PB, MA_TO, MA_NV, SO_THUCHIEN From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_SL_CSKHH_004') and loai = 3 and ma_nv in ('VNP017072');
--========== SỐ LƯỢNG TỔ
--========== SỐ LƯỢNG PHÓ GIÁM ĐỐC
--====================================================================================================--


--====================================================================================================--
--===== KẾT QUẢ SOSANH = 0 HẾT TẤT CẢ => OK
--=== CA NHAN
Select * From (
    Select b.MA_NV MA_NV_BL, b.THUCHIEN
           , a.SO_THUCHIEN - b.THUCHIEN SOSANH_TH
           , a.MA_NV, a.SO_THUCHIEN
    From 
       (  Select *
            From TTKD_BSC.bangluong_kpi a
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and MA_KPI = 'HCM_SL_CSKHH_004'
                  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                                Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                      and ma_kpi = 'HCM_SL_CSKHH_004'               -- <== LƯU Ý MÃ KPI
                                      and giamdoc_phogiamdoc is null                -- <== LƯU Ý VỊ TRÍ NV
                                      and to_truong_pho is null                     -- <== LƯU Ý VỊ TRÍ NV
                             )
       ) b
	Left join
       (  Select * from TONGHOP_BSC_KPI_2024 where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004' ) a
    On a.ma_nv = b.ma_nv
)Where SOSANH_TH > 0 Or SOSANH_TH is null;
--====================================================================================================--
