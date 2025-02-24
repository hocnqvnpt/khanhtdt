--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG TONGHOP_BSC_KPI
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Tỷ lệ chuẩn hóa thông tin khách hàng';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004');
--=== KIEM TRA VTCV THEO MA_KPI - KIỂM TRA ĐẠ ĐỦ VỊ TRÍ CV NHƯ THEO VB HAY CHƯA
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TONDV_004';
Select distinct dichvu From ttkd_bsc.blkpi_dm_to_pgd a where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm');  and nvl(dichvu,'a') not in ('Mega+Fiber','MyTV','VNP tra sau','VNP tra truoc')

--=== FILE KQ
Select * From BSC_CHTTKH_202501;
Select da_chuanhoa, dexuat_loai, sum(da_chuanhoa)da_chuanhoa, sum(so_giao)so_giao From BSC_CHTTKH_202501 Group by da_chuanhoa, dexuat_loai;
--=== SO THUC HIEN CA NHAN
Select ma_nv_am ma_nv, count(ma_tt_one)SO_THUCHIEN
From BSC_CHTTKH_202501 a
Where DA_CHUANHOA = 1
Group by ma_nv_am;

--====================================================================================================--
--===== CẬP NHẬT BÀNG TONGHOP_BSC_KPI - MÃ KPI = HCM_CL_TONDV_004
--====================================================================================================--
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004');
Delete From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004');
Commit;
--========== SỐ LƯỢNG VỊ TRÍ CÁ NHÂN
Insert Into TONGHOP_BSC_KPI_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI
    , MA_PB, MA_TO, MA_NV, MA_VTCV, TINH_BSC
    , SO_GIAO, SO_THUCHIEN
)
(   
	Select (to_char(trunc(sysdate, 'month')-1, 'yyyymm'))thang, (1)LOAI, ('KPI_NV')LOAI_KPI, ('HCM_CL_TONDV_004')MA_KPI, ('Tỷ lệ chuẩn hóa thông tin khách hàng')TEN_KPI
           , a.ma_pb_th, a.ma_to, a.ma_nv_am, a.ma_vtcv, a.tinh_bsc
           , a.SO_GIAO, a.SO_THUCHIEN
	From (
			Select ma_pb_th, ma_to, ma_nv_am, ma_vtcv, tinh_bsc, sum(SO_GIAO)SO_GIAO, sum(da_chuanhoa)SO_THUCHIEN
			From BSC_CHTTKH_202501 a
			Group by ma_pb_th, ma_to, ma_nv_am, ma_vtcv, tinh_bsc
		 ) a
);
Commit;
--========== SỐ LƯỢNG VỊ TRÍ TỔ TRƯỞNG, TRƯỞNG LINE
--Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004') and loai = 2;
--Delete From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004') and loai = 2;
Insert Into TONGHOP_BSC_KPI_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI
    , MA_PB, MA_TO, MA_NV, MA_VTCV
    , SO_GIAO, SO_THUCHIEN
)
(   
	Select nv.thang, (2)LOAI, ('KPI_TO')LOAI_KPI, ('HCM_CL_TONDV_004')MA_KPI, ('Tỷ lệ chuẩn hóa thông tin khách hàng')TEN_KPI
           , nv.ma_pb, nv.ma_to, nv.ma_nv, nv.ma_vtcv
           , b.SO_GIAO, b.SO_THUCHIEN
    From (
            Select THANG, MA_PB, MA_TO, MA_NV, MA_VTCV
            From ttkd_bsc.nhanvien nv
            Where nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD'
                  and exists (	--=== CAP NHAT THEO VTCV
                                Select * From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                                Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                      and ma_kpi in ('HCM_CL_TONDV_004')
                                      and to_truong_pho = 1
                                      and MA_VTCV = nv.MA_VTCV )
			Group by THANG, MA_PB, MA_TO, MA_NV, MA_VTCV
         ) nv
    Left join
        (
            Select MA_TO, sum(SO_GIAO)SO_GIAO, sum(SO_THUCHIEN)SO_THUCHIEN
            From khanhtdt_ttkd.TONGHOP_BSC_KPI_2024
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and ma_kpi = 'HCM_CL_TONDV_004'
                  and loai = 1
            Group by MA_TO
         ) b
    On nv.MA_TO = b.MA_TO
    Where b.SO_THUCHIEN is not null
);
Commit;
/*
--========== SỐ LƯỢNG VỊ TRÍ PGĐ PHỤ TRÁCH TỔ
--Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004') and loai = 3;
Insert Into TONGHOP_BSC_KPI_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI, PHUTRACH
    , MA_PB, MA_NV, MA_VTCV
    , SO_GIAO, SO_THUCHIEN
)
(   --===== SAN LUONG PHO GIAM DOC PHU TRACH TO
    Select THANG, (3)LOAI, 'KPI_PB' LOAI_KPI, 'HCM_CL_TONDV_004' MA_KPI, ('Tỷ lệ chuẩn hóa thông tin khách hàng')TEN_KPI, ('TO')PHUTRACH
		   , MA_PB, MA_NV, MA_VTCV
           , sum(SO_GIAO)SO_GIAO, sum(SO_THUCHIEN)SO_THUCHIEN
    From (
            Select a.THANG, a.MA_PB, a.MA_TO, a.MA_NV, a.MA_VTCV
                   , b.SO_GIAO, b.SO_THUCHIEN
            From (	--===== MA_NV PHÓ GIÁM ĐỐC PHỤ TRÁCH TỔ
                    Select thang, ma_pb, ma_to, ma_nv, ma_vtcv
                    From ttkd_bsc.blkpi_dm_to_pgd a
                    where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') 
                          and ma_kpi = 'HCM_CL_TONDV_004'
                          and upper(phutrach) = 'TO'
                          and exists (  --=== LẤY VỊ TRÍ PGĐ TRONG BẢNG DANH MỤC
                                        Select * From ttkd_bsc.blkpi_danhmuc_kpi_vtcv
                                        Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                              and ma_kpi = 'HCM_CL_TONDV_004'
                                              and GIAMDOC_PHOGIAMDOC = 1
                                              and ma_vtcv = a.ma_vtcv )
                    Group by thang, ma_pb, ma_to, ma_nv, ma_vtcv
                 ) a
            Left join
                (   
                    Select MA_TO, sum(SO_GIAO)SO_GIAO, sum(SO_THUCHIEN)SO_THUCHIEN
                    From khanhtdt_ttkd.TONGHOP_BSC_KPI_2024
                    Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                          and ma_kpi = 'HCM_CL_TONDV_004'
                          and loai = 1
                    Group by MA_TO
                ) b
            On a.MA_TO = b.MA_TO
         )
    Where SO_THUCHIEN is not null
    Group by THANG, MA_PB, MA_NV, MA_VTCV
);
Commit;
--========== SỐ LƯỢNG VỊ TRÍ PGĐ PHỤ TRÁCH PHÒNG
--Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004') and loai = 3 and PHUTRACH = 'PHONG';
--Delete From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TONDV_004') and loai = 3 and PHUTRACH = 'PHONG';
Insert Into TONGHOP_BSC_KPI_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI, PHUTRACH
    , MA_PB, MA_NV, MA_VTCV
    , SO_GIAO, SO_THUCHIEN
)
(   --===== SAN LUONG PHO GIAM DOC PHU TRACH TO
    Select THANG, (3)LOAI, 'KPI_PB' LOAI_KPI, 'HCM_CL_TONDV_004' MA_KPI, ('Tỷ lệ chuẩn hóa thông tin khách hàng')TEN_KPI, ('PHONG')PHUTRACH
		   , MA_PB, MA_NV, MA_VTCV
           , sum(SO_GIAO)SO_GIAO, sum(SO_THUCHIEN)SO_THUCHIEN
    From (
            Select a.THANG, a.MA_PB, a.MA_NV, a.MA_VTCV, b.SO_GIAO, b.SO_THUCHIEN
            From (	--===== MA_NV PHÓ GIÁM ĐỐC PHỤ TRÁCH PHÒNG
                    Select thang, ma_pb, ma_nv, ma_vtcv
                    From ttkd_bsc.blkpi_dm_to_pgd a
                    where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') 
                          and ma_kpi = 'HCM_CL_TONDV_004'
                          and upper(phutrach) = 'PHONG'
                          and exists (  --=== LẤY VỊ TRÍ PGĐ TRONG BẢNG DANH MỤC
                                        Select * From ttkd_bsc.blkpi_danhmuc_kpi_vtcv
                                        Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                              and ma_kpi = 'HCM_CL_TONDV_004'
                                              and GIAMDOC_PHOGIAMDOC = 1
                                              and ma_vtcv = a.ma_vtcv )
                    Group by thang, ma_pb, ma_nv, ma_vtcv
                 ) a
            Left join
                (   
                    Select MA_PB, sum(SO_GIAO)SO_GIAO, sum(SO_THUCHIEN)SO_THUCHIEN
                    From khanhtdt_ttkd.TONGHOP_BSC_KPI_2024
                    Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                          and ma_kpi = 'HCM_CL_TONDV_004'
                          and loai = 1
                    Group by MA_PB
                ) b
            On a.MA_PB = b.MA_PB
         )
    Where SO_THUCHIEN is not null
    Group by THANG, MA_PB, MA_NV, MA_VTCV
);
Commit;
--====================================================================================================--
*/