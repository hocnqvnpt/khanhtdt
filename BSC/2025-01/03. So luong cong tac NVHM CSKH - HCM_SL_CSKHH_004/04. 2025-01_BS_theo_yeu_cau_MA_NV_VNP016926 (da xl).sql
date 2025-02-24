--===================================================================================--
--===== BO SUNG SO THUC HIEN THEO YEU CAU P.BH ONL - MAIL ngày 03/12/2024       =====--
--===================================================================================--
--===== ma_kpi = 'HCM_SL_CSKHH_004' =====--

--====================================================================================================--
--=== TONGHOP_BSC_KPI_2024 - ĐỂ LƯU
--===
Select * From ttkd_bsc.nhanvien Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD' and ma_nv in ('VNP016926');
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004' and loai = 1 and ma_nv in ('VNP016926');
--=== VNP016926 - chị Mỹ Loan - SO_THUCHIEN, TONGTIEN
--=== cập nhật số thực hiện, chị Mỹ Loan theo file P.BH Onl gửi mail ngày 03/12/2024
Update TONGHOP_BSC_KPI_2024
    Set SO_THUCHIEN = 1268
		, TONGTIEN = 1268 * 6000
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
      and ma_kpi = 'HCM_SL_CSKHH_004'
	  and loai = 1
      and ma_nv = 'VNP016926';
Commit;
--====================================================================================================--
--=== TTKD_BSC.BANGLUONG_KPI
Select * From ttkd_bsc.nhanvien Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD' and ma_nv in ('VNP016926');
Select * From ttkd_bsc.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004' and ma_nv in ('VNP016926');
--========== SỐ LƯỢNG CÁ NHÂN
Update ttkd_bsc.bangluong_kpi a
	set a.THUCHIEN = 1268
Where a.THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
	  and a.MA_NV = 'VNP016926';
Commit;
--========== TY LE THUC HIEN
Update ttkd_bsc.bangluong_kpi a
    Set a.TYLE_THUCHIEN = Round ( (nvl(THUCHIEN,0)*100)/GIAO, 2)
Where a.THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
	  and a.MA_NV = 'VNP016926';
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
	  and a.MA_NV = 'VNP016926';
Commit;