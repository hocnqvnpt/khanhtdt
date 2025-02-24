--===================================================================================--
--===== BỔ SUNG SỐ PHIẾU TỒN QUÁ HẠN P.BH ONL - MAIL ngày 03/12/2024  =====--
--===================================================================================--
--===== ma_kpi = 'HCM_SL_BHOL_001' =====--

--====================================================================================================--
--=== TONGHOP_BSC_KPI_2024 - ĐỂ LƯU
--===
Select * From ttkd_bsc.nhanvien Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD' and ma_nv in ('VNP016926');
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' and loai = 1 and ma_nv in ('VNP016926');
--=== VNP016926 - chị Mỹ Loan - so_giao, SO_THUCHIEN
--=== cập nhật số thực hiện, chị Mỹ Loan theo file P.BH Onl gửi mail ngày 03/12/2024
Delete From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' and loai = 1 and ma_nv in ('VNP016926');
Insert Into KHANHTDT_TTKD.tonghop_bsc_kpi_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI
    , MA_PB, MA_TO, MA_NV, MA_VTCV, TINH_BSC
    , NGAYCONG_CHUAN, SO_GIAO, SO_THUCHIEN
)
(   
	Select nv.thang, (1)LOAI, ('KPI_NV')LOAI_KPI, ('HCM_SL_BHOL_001')MA_KPI, ('Tỷ lệ nghiệp vụ xử lý quá hạn')TEN_KPI
           , nv.ma_pb, nv.ma_to, nv.ma_nv, nv.ma_vtcv, nv.tinh_bsc
           , (22)NGAYCONG_CHUAN, (1)SO_GIAO, (0)SO_THUCHIEN
    From ttkd_bsc.nhanvien nv
    Where nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
          and nv.ma_nv in ('VNP016926')
);
Commit;
--====================================================================================================--