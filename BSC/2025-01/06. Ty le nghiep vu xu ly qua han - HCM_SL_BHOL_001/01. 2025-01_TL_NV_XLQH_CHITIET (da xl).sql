--====================================================================================================
--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG TONGHOP_BSC_KPI
--====================================================================================================
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Tỷ lệ nghiệp vụ xử lý quá hạn';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001';
--=====
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001'; --02 vt NV ; 1 vt PGD ; 2 vt TT ; 1 vt Truong ca
Select * From ttkd_bsc.nhanvien
where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD'                       -- 10 nv ; 2 pgđ ; 1 trường ca ; 2 tổ trưởng = 15 nv tinh_bsc = 1
      and ma_vtcv in ('VNP-HNHCM_KDOL_16.3','VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_2','VNP-HNHCM_KDOL_24.1','VNP-HNHCM_KDOL_18','VNP-HNHCM_KDOL_23');
Select * From ttkd_bsc.bangluong_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001'; -- 10 nv ; 1 pgđ (loai tru Tuyet) ; 1 trường ca ; 2 tổ trưởng = 15 nv 
--=== KIEM TRA VTCV THEO MA_KPI - KIỂM TRA ĐẠ ĐỦ VỊ TRÍ CV NHƯ THEO VB HAY CHƯA
Select * From TTKD_BSC.blkpi_dm_to_pgd@ttkddb where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001'; --and ma_pb = 'VNP0703000';

--=== FILE KQ
Select * From KHANHTDT_TTKD.bsc_ton_quahan Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_nv = 'VNP016926'; --and to_char(a.ngay_cn,'yyyymmdd') = '' 
--====================================================================================================--
--===== CẬP NHẬT BÀNG TONGHOP_BSC_KPI - MA_KPI = HCM_SL_BHOL_001
--====================================================================================================--
Select * From KHANHTDT_TTKD.tonghop_bsc_kpi_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' and ma_nv = 'VNP016926';
Delete From KHANHTDT_TTKD.tonghop_bsc_kpi_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001';
Commit;
--========== SỐ LƯỢNG VỊ TRÍ CÁ NHÂN
Insert Into KHANHTDT_TTKD.tonghop_bsc_kpi_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI
    , MA_PB, MA_TO, MA_NV, MA_VTCV, TINH_BSC
    , NGAYCONG_CHUAN, SO_GIAO, SO_THUCHIEN
)
(   
	Select nv.thang, (1)LOAI, ('KPI_NV')LOAI_KPI, ('HCM_SL_BHOL_001')MA_KPI, ('Tỷ lệ nghiệp vụ xử lý quá hạn')TEN_KPI
           , nv.ma_pb, nv.ma_to, a.ma_nv, nv.ma_vtcv, nv.tinh_bsc
           , (22)NGAYCONG_CHUAN, a.SO_GIAO, a.SO_THUCHIEN
	From (
			Select ma_nv, sum(tong)SO_GIAO, sum(KQ_TON_QUAHAN)SO_THUCHIEN
			From BSC_TON_QUAHAN
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
				  --and to_char(NGAY_CHOT_ID164,'yyyymmdd') = '20250115'							-- LƯU Ý NGÀY CẬP NHẬT DO HỘI CHỐT LẠI LẦN 2
			Group by ma_nv
		 ) a
	Left join TTKD_BSC.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD' and nv.ma_nv = a.ma_nv
);
Commit;
--====== BỔ SUNG SỐ LIỆU CHO MA_NV = VNP016926 (MỸ Loan)
--Select * From KHANHTDT_TTKD.tonghop_bsc_kpi_2024 a Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and a.ma_kpi = 'HCM_SL_BHOL_001' and a.ma_nv in ('VNP016926');
Update KHANHTDT_TTKD.tonghop_bsc_kpi_2024 a
	Set SO_GIAO = 1859, SO_THUCHIEN = 0
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
      and a.ma_kpi = 'HCM_SL_BHOL_001'  
      and a.loai = 1
      and a.ma_nv in ('VNP016926');
--Rollback;
Commit;
--========== SỐ LƯỢNG VỊ TRÍ TỔ TRƯỞNG, TRƯỞNG LINE
--Select * From KHANHTDT_TTKD.tonghop_bsc_kpi_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' and loai = 1;
--Select * From KHANHTDT_TTKD.tonghop_bsc_kpi_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' and loai = 2;
Insert Into KHANHTDT_TTKD.tonghop_bsc_kpi_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI
    , MA_PB, MA_TO, MA_NV, MA_VTCV, TINH_BSC
    , NGAYCONG_CHUAN, SO_GIAO, SO_THUCHIEN
)
(   
	Select nv.thang, (2)LOAI, ('KPI_TO')LOAI_KPI, a.MA_KPI, a.TEN_KPI
           , a.ma_pb, a.ma_to, nv.ma_nv, nv.ma_vtcv, nv.tinh_bsc
           , (22)NGAYCONG_CHUAN, a.SO_GIAO, a.SO_THUCHIEN
	From (
			Select THANG, MA_KPI, TEN_KPI, MA_PB, MA_TO, sum(SO_GIAO)SO_GIAO, sum(SO_THUCHIEN)SO_THUCHIEN
			From KHANHTDT_TTKD.tonghop_bsc_kpi_2024 a
			Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
				  and ma_kpi = 'HCM_SL_BHOL_001'
				  and loai = 1
				  and exists (  Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
								Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
								      and ma_kpi = 'HCM_SL_BHOL_001'
									  and GIAMDOC_PHOGIAMDOC is null
									  and ma_vtcv = a.ma_vtcv
							 )
			Group by THANG, MA_KPI, TEN_KPI, MA_PB, MA_TO
		 ) a
	Join TTKD_BSC.nhanvien nv
	On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD'
	   and nv.ma_to = a.ma_to
	   and exists (  Select 1 From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
						   and ma_kpi = 'HCM_SL_BHOL_001'
						   and TO_TRUONG_PHO = 1
						   and ma_vtcv = nv.ma_vtcv
				  )
);
Commit;
--========== SỐ LƯỢNG VỊ TRÍ PGĐ PHỤ TRÁCH
--Select * From KHANHTDT_TTKD.tonghop_bsc_kpi_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001' and loai = 3;
Insert Into KHANHTDT_TTKD.tonghop_bsc_kpi_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI
    , MA_PB, MA_NV, MA_VTCV
    , NGAYCONG_CHUAN, SO_GIAO, SO_THUCHIEN
)
(   --===== SAN LUONG PHO GIAM DOC PHU TRACH TO
	Select THANG, (3)LOAI, ('KPI_PB')LOAI_KPI, ('HCM_SL_BHOL_001')MA_KPI, ('Tỷ lệ nghiệp vụ xử lý quá hạn')TEN_KPI
           , MA_PB, MA_NV, MA_VTCV
           , (22)NGAYCONG_CHUAN, SO_GIAO, SO_THUCHIEN
    From (	--=== SỐ LƯỢNG THEO MA_NV PHÓ GIÁM ĐỐC PHỤ TRÁCH
            Select thang, ma_pb, ma_nv, ma_vtcv, sum(SO_GIAO)SO_GIAO, sum(SO_THUCHIEN)SO_THUCHIEN
			From (
					Select a.THANG, a.MA_PB, a.MA_TO, a.MA_NV, a.MA_VTCV, b.SO_GIAO, b.SO_THUCHIEN
					From (	--===== MA_NV PHÓ GIÁM ĐỐC PHỤ TRÁCH TỔ
                            Select thang, ma_kpi, ma_pb, ma_to, ma_nv, ten_nv, ma_vtcv
                            From TTKD_BSC.blkpi_dm_to_pgd a
                            where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') 
                                  and ma_kpi = 'HCM_SL_BHOL_001'
                                  and phutrach = 'To'
                                  and exists (  --=== LẤY VỊ TRÍ PGĐ TRONG BẢNG DANH MỤC
                                                Select * From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                                                Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                                      and ma_kpi = 'HCM_SL_BHOL_001'
                                                      and GIAMDOC_PHOGIAMDOC = 1
                                                      and ma_vtcv = a.ma_vtcv )
                            Group by thang, ma_kpi, ma_pb, ma_to, ma_nv, ten_nv, ma_vtcv
						 ) a
					Left join
						(   --=== SL CA NHAN GROUP THANH SL TO
                            Select MA_TO, sum(SO_GIAO)SO_GIAO, sum(SO_THUCHIEN)SO_THUCHIEN
                            From KHANHTDT_TTKD.tonghop_bsc_kpi_2024
                            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                  and ma_kpi = 'HCM_SL_BHOL_001'
                                  and loai = 2
                                  and ma_vtcv in ('VNP-HNHCM_KDOL_23','VNP-HNHCM_KDOL_18')          -- chỉ lấy vị trí tổ trưởng không lấy trưởng ca
                            Group by MA_TO
					   ) b
					On a.ma_to = b.ma_to
					Order by ma_nv, ma_to, ma_pb
				 )
            Where SO_THUCHIEN is not null
			Group by thang, ma_pb, ma_nv, ma_vtcv
            Order by ma_nv, ma_pb
         )
);
Commit;
--====================================================================================================--
--Select * From KHANHTDT_TTKD.tonghop_bsc_kpi_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_BHOL_001';
Update KHANHTDT_TTKD.tonghop_bsc_kpi_2024 a
	Set TYLE = round( 100-(SO_THUCHIEN/SO_GIAO)*100, 2)
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
      and a.ma_kpi = 'HCM_SL_BHOL_001';
Commit;
Update KHANHTDT_TTKD.tonghop_bsc_kpi_2024 a
	Set MUCDO_HT = (Case when a.TYLE >= 99 then 100
                         when (a.TYLE >= 60 and a.TYLE < 99) then Round(a.TYLE * 0.5, 2)
                         when a.TYLE < 60 then Round(a.TYLE * 0.25, 2)
                    End)
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
      and a.ma_kpi = 'HCM_SL_BHOL_001';
Commit;
