--===== Muc dich la Insert vào bàng bangluong_kpi
Select trim(cot01) ma_nv, to_number(cot02,9999999999)giao From A_A;

--====================================================================================================--
--===== CẬP NHẬT BẢNG LƯƠNG KPI THEO VỊ TRÍ CÔNG VIỆC
--===== Select * From bangluong_kpi where thang = 202501;
--===== MÃ KPI = HCM_SL_CSKHH_004 ==> dành cho nhân viên
--====================================================================================================--
Select * From ttkd_bsc.bangluong_kpi Where thang = 202501 and MA_KPI = 'HCM_SL_CSKHH_004' Order by ma_vtcv, giao;
--========== SỐ GIAO CÁ NHÂN - theo số trên vb quy định ('VNP-HNHCM_KDOL_16.3','VNP-HNHCM_KDOL_22') = 1020
--===== Copy tat ca MA_NV có số giao 1020 vao cot01 bang A_A
Update ttkd_bsc.bangluong_kpi a
	Set a.GIAO = ( Select to_number(b.cot02)giao
                   From A_A b
                   Where a.ma_nv = trim(b.cot01)
                 )
    -- do ngày công tháng 01/2025 có 17
Where a.THANG = 202501
	  and a.MA_KPI = 'HCM_SL_CSKHH_004'
	  and exists ( Select 1 From A_A Where trim(cot01) = a.ma_nv)
;
Commit;
--====================================================================================================--
--===== TEST UP DATE
Select a.ma_nv, a.giao, b.sogiao, a.giao - b.sogiao
From (Select ma_nv, giao From ttkd_bsc.bangluong_kpi Where thang = 202501 and MA_KPI = 'HCM_SL_CSKHH_004') a
Left join (Select trim(cot01) ma_nv, to_number(cot02,9999999999)sogiao From A_A) b
On a.ma_nv = b.ma_nv
--====================================================================================================--
