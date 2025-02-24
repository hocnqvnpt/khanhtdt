--===================================================================================--
--===== BO SUNG SO THUC HIEN THEO YEU CAU P.BH ONL - MAIL ngày 10/02/2025       =====--
--===================================================================================--
--===== ma_kpi = 'HCM_SL_CSKHH_004' =====--

--====================================================================================================--
--=== TONGHOP_BSC_KPI_2024 - ĐỂ LƯU
--===
Select * From ttkd_bsc.nhanvien Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD' and ma_nv in ('CTV021804');
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004' and loai = 1 and ma_nv in ('CTV021804');
--=== CTV021804 - chị Đào Hồng Vân - SO_THUCHIEN, TONGTIEN
--=== cập nhật số thực hiện, chị Đào Hồng Vân theo file P.BH Onl gửi mail ngày 03/12/2024
Update TONGHOP_BSC_KPI_2024
    Set SO_THUCHIEN = 973
		, TONGTIEN = 973 * 6000
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
      and ma_kpi = 'HCM_SL_CSKHH_004'
	  and loai = 1
      and ma_nv = 'CTV021804';
Commit;
--====================================================================================================--
--=== TTKD_BSC.BANGLUONG_KPI
Select * From ttkd_bsc.nhanvien Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD' and ma_nv in ('CTV021804');
Select * From ttkd_bsc.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004' and ma_nv in ('CTV021804');
--========== SỐ LƯỢNG CÁ NHÂN
Update ttkd_bsc.bangluong_kpi a
	set a.THUCHIEN = 973
Where a.THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
	  and a.MA_NV = 'CTV021804';
Commit;
--========== TY LE THUC HIEN
Update ttkd_bsc.bangluong_kpi a
    Set a.TYLE_THUCHIEN = Round ( (nvl(THUCHIEN,0)*100)/GIAO, 2)
Where a.THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
	  and a.MA_NV = 'CTV021804';
Commit;
--========== MUC DO HOAN THANH
Update ttkd_bsc.bangluong_kpi a
    Set a.MUCDO_HOANTHANH
         = (Case when  TYLE_THUCHIEN >= 100 then 120
                 when (TYLE_THUCHIEN >= 80 and TYLE_THUCHIEN < 100) then 100 + (TYLE_THUCHIEN-80)
                 when  TYLE_THUCHIEN < 80 then TYLE_THUCHIEN
            end)
Where a.THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
	  and a.MA_NV = 'CTV021804';
Commit;