--=== Số lượng công tác nghiệp vụ, hậu mãi, CSKH - HCM_SL_CSKHH_004
--=== Bắt đầu từ tháng 202411 chỉ còn vị trí công việc của P.ONLINE

-- Số lượng công tác nghiệp vụ,  hậu mãi, CSKH
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Số lượng công tác nghiệp vụ, hậu mãi, CSKH';  -- bắt đầu từ tháng 202411 không còn KHDN
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_SL_CSKHH_004');                             -- bắt đầu từ tháng 202411 không còn KHDN
--=== KIEM TRA VTCV THEO MA_KPI
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004';
Select * From ttkd_bsc.nhanvien
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD'
      and ma_vtcv in ('VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_16.1','VNP-HNHCM_KDOL_16.2','VNP-HNHCM_KDOL_16.3'); -- 33 nv tinh_bsc = 1
Select * From ttkd_bsc.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004'; -- 33 nv

--====================================================================================================--
--===== TONGHOP_BSC_KPI_2024
--===== Thàng 202410 ==> MÃ KPI = HCM_SL_CSKHH_004 ==> count(ID_YCKH)
--====================================================================================================--
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004';
Delete From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004';
--======================================== CÁ NHÂN
Insert Into TONGHOP_BSC_KPI_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI
    , SO_THUCHIEN
    , MA_PB, MA_TO, MA_NV, MA_VTCV, TINH_BSC    )
(   --===== SAN LUONG CA NHAN =====> HCM_SL_CSKHH_004
    Select THANG, (1)LOAI, ('KPI_NV')LOAI_KPI, ('HCM_SL_CSKHH_004')MA_KPI, ('Số lượng công tác nghiệp vụ,  hậu mãi, CSKH')TEN_KPI
           , SO_THUCHIEN
           , MA_PB, MA_TO, MA_NV, MA_VTCV, TINH_BSC    				                        -- <= LUU Y SL CA NHAN = MA_PB, MA_TO, MA_NV 
    From (
            Select a.THANG, a.MA_PB, a.MA_TO, a.MA_NV, nv.ma_vtcv, nv.tinh_bsc
                   , a.SO_THUCHIEN
            From (
                    Select THANG, MA_PB, MA_TO, MA_NV
                           , count(ID_YCKH)SO_THUCHIEN
                    From ttkd_bsc.ktdt_ct_bsc_xl_nghievu_cskh
                    Where thang = to_char(trunc(sysdate,'month')-1, 'yyyymm')
                    Group by THANG, MA_PB, MA_TO, MA_NV
                    Order by MA_PB
                  ) a  
            Left join ttkd_bsc.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD' and a.MA_NV = nv.ma_nv
         )
);
Commit;
/* ----------------------------------------------------
   -- Update theo yêu cầu P.BHONL - Mail của Hồng Duyên
   ---------------------------------------------------- */
/* - Hồng Duyên sửa lại 100 vì ds giao 100 */
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004' and ma_nv in ('CTV076800','CTV081976','CTV086129','CTV086121','CTV080931');
Select * From ttkd_bsc.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004' and ma_nv in ('CTV076800','CTV081976','CTV086129','CTV086121','CTV080931');
Update TONGHOP_BSC_KPI_2024 a
	Set a.SO_THUCHIEN = 100
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_SL_CSKHH_004'
	  and a.ma_nv in ('CTV076800','CTV081976','CTV086129','CTV086121','CTV080931');
Commit;
/* - Hồng Duyên yêu cầu 400 vì ds giao 400 */
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004' and ma_nv in ('CTV076445');
Select * From ttkd_bsc.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004' and ma_nv in ('CTV076445');
Update TONGHOP_BSC_KPI_2024 a
	Set a.SO_THUCHIEN = 400
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_SL_CSKHH_004'
	  and a.ma_nv in ('CTV076445');
Commit;
/* ----------------------------------------------------
   -- Update theo yêu cầu P.BHONL - Mail của chị Thủy
   ---------------------------------------------------- */
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004' and ma_nv in (Select ma_nv From A_ONL);
Delete From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004' and ma_nv in (Select ma_nv From A_ONL);
Insert Into TONGHOP_BSC_KPI_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI
    , SO_THUCHIEN
    , MA_PB, MA_TO, MA_NV, MA_VTCV, TINH_BSC    )
(   --===== SAN LUONG CA NHAN =====> HCM_SL_CSKHH_004
    Select THANG, (1)LOAI, ('KPI_NV')LOAI_KPI, ('HCM_SL_CSKHH_004')MA_KPI, ('Số lượng công tác nghiệp vụ,  hậu mãi, CSKH')TEN_KPI
           , SO_THUCHIEN
           , MA_PB, MA_TO, MA_NV, MA_VTCV, TINH_BSC    				                        -- <= LUU Y SL CA NHAN = MA_PB, MA_TO, MA_NV 
    From (
            Select nv.THANG, nv.MA_PB, nv.MA_TO, a.MA_NV, nv.ma_vtcv, nv.tinh_bsc
                   , a.SO_THUCHIEN
            From (
                    Select distinct MA_NV, SL_TH SO_THUCHIEN From A_ONL
                  ) a  
            Left join ttkd_bsc.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD' and a.MA_NV = nv.ma_nv
         )
);
Commit;
--========== TỔNG TIỀN
Update TONGHOP_BSC_KPI_2024 a
	Set a.DONGIA = 6000, a.TONGTIEN = SO_THUCHIEN * 6000
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.ma_kpi = 'HCM_SL_CSKHH_004'
	  and a.ma_vtcv in ('VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_16.3')
      --and not exists ( Select 1 From A_ONL Where a.ma_nv = ma_nv )
      and a.ma_nv not in ('VNP016926','VNP019496','VNP019901','VNP017862','VNP033237'
                          ,'VNP029933','VNP028207','VNP020229','VNP019903','VNP017800')
;
Commit;
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004' and TONGTIEN > 0;
Select * From TONGHOP_BSC_KPI_2024 Where ma_kpi = 'HCM_SL_CSKHH_004' and TONGTIEN > 0 and ma_nv = 'VNP017064' Order by thang;
/* - TỔ TRƯỜNG - vb thang 10/2024 không có */
/* - PHÓ GIÀM ĐỐC - vb thang 10/2024 không có */
--=== TEST NGAU NHIEN
Select THANG, MA_PB, MA_TO, MA_NV, sum(SO_THUCHIEN)SO_THUCHIEN From TONGHOP_BSC_KPI_2024
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004'
Group by THANG, MA_PB, MA_TO, MA_NV Order by MA_PB, MA_TO;
--=== CN P.Onl va CN KHDN
Select THANG, MA_PB, MA_TO, MA_NV, count(ID_YCKH)SO_THUCHIEN From ttkd_bsc.ktdt_ct_bsc_xl_nghievu_cskh
Where thang = to_char(trunc(sysdate,'month')-1, 'yyyymm') and MA_NV = 'VNP017771'
Group by THANG, MA_PB, MA_TO, MA_NV Order by MA_PB, MA_TO;
--====================================================================================================--
