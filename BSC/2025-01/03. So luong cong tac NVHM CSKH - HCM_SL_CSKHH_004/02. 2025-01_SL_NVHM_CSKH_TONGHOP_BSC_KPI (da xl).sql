--=== Số lượng công tác nghiệp vụ, hậu mãi, CSKH - HCM_SL_CSKHH_004
--=== Bắt đầu từ tháng 202411 chỉ còn vị trí công việc của P.ONLINE

-- Số lượng công tác nghiệp vụ,  hậu mãi, CSKH
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Số lượng công tác nghiệp vụ, hậu mãi, CSKH';  -- bắt đầu từ tháng 202411 không còn KHDN
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_SL_CSKHH_004');                             -- bắt đầu từ tháng 202411 không còn KHDN
--=== KIEM TRA VTCV THEO MA_KPI
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004';
Select * From ttkd_bsc.nhanvien
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD'
      and ma_vtcv in ('VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_16.1','VNP-HNHCM_KDOL_16.2','VNP-HNHCM_KDOL_16.3'); -- 28 nv tinh_bsc = 1
Select * From ttkd_bsc.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004'; -- 28 nv

--====================================================================================================--
--===== TONGHOP_BSC_KPI_2024
--===== Thàng 202410 ==> MÃ KPI = HCM_SL_CSKHH_004 ==> count(ID_YCKH)
--====================================================================================================--
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004';
Delete From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004';
Commit;
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
                    Select THANG, MA_PB, MA_TO, MA_NV, count(ID_YCKH)SO_THUCHIEN
                    From ttkd_bsc.ktdt_ct_bsc_xl_nghievu_cskh
                    Where thang = to_char(trunc(sysdate,'month')-1, 'yyyymm')
                    Group by THANG, MA_PB, MA_TO, MA_NV
                    Order by MA_PB
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
      and loai = 1
	  and a.ma_vtcv in ('VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_16.3');
Commit;
--======================================== TỔ TRƯỜNG - vb thang 10/2024 không có
--======================================== PHÓ GIÀM ĐỐC - vb thang 10/2024 không có
--====================================================================================================--
--=== TEST NGAU NHIEN
Select THANG, MA_PB, MA_TO, MA_NV, sum(SO_THUCHIEN)SO_THUCHIEN From TONGHOP_BSC_KPI_2024
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004'
Group by THANG, MA_PB, MA_TO, MA_NV Order by MA_PB, MA_TO;
--=== CN P.Onl va CN KHDN
Select THANG, MA_PB, MA_TO, MA_NV, count(ID_YCKH)SO_THUCHIEN From ttkd_bsc.ktdt_ct_bsc_xl_nghievu_cskh
Where thang = to_char(trunc(sysdate,'month')-1, 'yyyymm') and MA_NV = 'CTV021804'
Group by THANG, MA_PB, MA_TO, MA_NV Order by MA_PB, MA_TO;
--====================================================================================================--
