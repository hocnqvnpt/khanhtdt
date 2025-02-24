--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG LUONG KPI
--===== THEO VTCT VÀ MA KPI
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Số lượng cuộc gọi OB thành công';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi like 'HCM_CL_TNGOI_006'; -- => OK
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_006'); -- => tháng 10/2024: chỉ có NV CSKH TS (ONLINE)
Select * From ttkd_bsc.nhanvien Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_vtcv in ('VNP-HNHCM_KDOL_24'); --4 nv - 2 nv tinh_bsc = 0

--====================================================================================================--
Select * From khanhtdt_ttkd.kq_ct_ipcc_cskhts_talktime where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm');
Select thang, ma_nv, count(*)SL
From khanhtdt_ttkd.kq_ct_ipcc_cskhts_talktime Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
Group by thang, ma_nv Order by ma_nv;
--====================================================================================================--

--====================================================================================================--
--=== TONGHOP_BSC_KPI_2024 - MA KPI = 'HCM_CL_TNGOI_006'
--=== SỐ LƯỢNG CUỘC GỌI THÀNH CÔNG TRÊN 10s ==> SO_THUCHIEN
--====================================================================================================--
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TNGOI_006' Order by loai, ma_pb, ma_to, ma_nv;
Delete From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TNGOI_006';
Commit;
--================================================== SAN LUONG VI TRI CÁ NHÂN
Insert Into TONGHOP_BSC_KPI_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI, MA_VTCV, TINH_BSC
    , SO_THUCHIEN
    , MA_PB, MA_TO, MA_NV
)
(   --===== SAN LUONG CA NHAN
	Select THANG, (1)LOAI, ('KPI_NV')LOAI_KPI, 'HCM_CL_TNGOI_006' ma_kpi, 'Số lượng cuộc gọi OB thành công' TEN_KPI, MA_VTCV, TINH_BSC
           , SO_THUCHIEN
		   , MA_PB, MA_TO, MA_NV                                                -- <= LUU Y SL CA NHAN = MA_PB, MA_TO, MA_NV
	From (
            Select a.THANG, a.MA_PB, a.MA_TO, a.MA_NV, nv.MA_VTCV, nv.TINH_BSC
                   , a.SO_THUCHIEN
            From (
                    Select THANG, MA_PB, MA_TO, MA_NV, count(MA_NV)SO_THUCHIEN
                    From khanhtdt_ttkd.kq_ct_ipcc_cskhts_talktime
                    Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                    Group by THANG, MA_PB, MA_TO, MA_NV
                    Order by MA_PB, MA_TO, MA_NV
                 ) a
            Left join ttkd_bsc.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD' and nv.ma_nv = a.ma_nv
		 )
);
Commit;
--========== TEST KQ NGẪU NHIÊN - CÁ NHÂN
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TNGOI_006' and loai = 1 Order by loai, ma_pb, ma_to, ma_nv;
--====================================================================================================--