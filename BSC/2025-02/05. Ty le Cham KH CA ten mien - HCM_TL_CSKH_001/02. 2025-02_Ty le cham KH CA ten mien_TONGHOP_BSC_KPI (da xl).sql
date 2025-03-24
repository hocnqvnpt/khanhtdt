--====================================================================================================
--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG TONGHOP_BSC_KPI
--====================================================================================================
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Tỷ lệ chạm khách hàng (Dịch vụ CA-IVAN và Tên miền)';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001';
--=====
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001'; --4 cv, 1 nv, 2 gd, 3 pgd, 1 truong line, 2 to truong

Select * From ttkd_bsc.nhanvien
where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD'                   -- 437 record
      and ma_vtcv in (Select ma_vtcv from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001');

Select * From ttkd_bsc.bangluong_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001'; -- 416 record
--=== KIEM TRA VTCV THEO MA_KPI - KIỂM TRA ĐẠ ĐỦ VỊ TRÍ CV NHƯ THEO VB HAY CHƯA
Select * From TTKD_BSC.blkpi_dm_to_pgd@ttkddb where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001'; --and ma_pb = 'VNP0703000';

--=== FILE KQ
Select * From BSC_TL_CSKH_CA_DOMAIN
Where thang_kt = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
      and SL_DA_THANHTOANHT = 0 and CHUYEN_ONL = 0;

--====================================================================================================--
--===== CẬP NHẬT BÀNG TONGHOP_BSC_KPI - MA_KPI = HCM_TL_CSKH_001
--====================================================================================================--
Select * From KHANHTDT_TTKD.tonghop_bsc_kpi_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001' Order by LOAI;
Delete From KHANHTDT_TTKD.tonghop_bsc_kpi_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_TL_CSKH_001';
--========== SỐ LƯỢNG VỊ TRÍ CÁ NHÂN
Insert Into KHANHTDT_TTKD.tonghop_bsc_kpi_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI
    , MA_PB, MA_TO, MA_NV, MA_VTCV, TINH_BSC
    , SO_GIAO, SO_THUCHIEN
)
(   
	Select nv.thang, (1)LOAI, ('KPI_NV')LOAI_KPI, ('HCM_TL_CSKH_001')MA_KPI, ('Tỷ lệ chạm khách hàng (Dịch vụ CA-IVAN và Tên miền)')TEN_KPI
           , nv.ma_pb, nv.ma_to, a.ma_nv, nv.ma_vtcv, nv.tinh_bsc
           , a.SO_GIAO, a.SO_THUCHIEN
	From (
			Select a.ma_nv_giao ma_nv, count(a.ma_nv_giao)SO_GIAO, count(b.ma_nv_giao)SO_THUCHIEN
			From BSC_TL_CSKH_CA_DOMAIN a
            Left join 
                (
                    Select ma_nv_giao
                    From BSC_TL_CSKH_CA_DOMAIN
                    Where thang_kt = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and SL_DA_THANHTOANHT = 0 and CHUYEN_ONL = 0
                          and (ten_ly_do is not null or ten_kq is not null)
                    --Group by ma_nv_giao
                ) b
            On a.ma_nv_giao = b.ma_nv_giao
            Where a.thang_kt = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and a.SL_DA_THANHTOANHT = 0 and a.CHUYEN_ONL = 0
			Group by a.ma_nv_giao
		 ) a
	Left join TTKD_BSC.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD' and nv.ma_nv = a.ma_nv
);
Commit;

--========== SỐ LƯỢNG VỊ TRÍ TỔ TRƯỞNG, TRƯỞNG LINE
--Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_TL_CSKH_001') and loai = 2;
--Delete From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_TL_CSKH_001') and loai = 2;
Insert Into TONGHOP_BSC_KPI_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI
    , MA_PB, MA_TO, MA_NV, MA_VTCV
    , SO_GIAO, SO_THUCHIEN
)
(   
	Select nv.thang, (2)LOAI, ('KPI_TO')LOAI_KPI, ('HCM_TL_CSKH_001')MA_KPI, ('Tỷ lệ chạm khách hàng (Dịch vụ CA-IVAN và Tên miền)')TEN_KPI
           , nv.ma_pb, nv.ma_to, nv.ma_nv, nv.ma_vtcv
           , b.SO_GIAO, b.SO_THUCHIEN
    From (
            Select THANG, MA_PB, MA_TO, MA_NV, MA_VTCV
            From ttkd_bsc.nhanvien nv
            Where nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD'
                  and exists (	--=== CAP NHAT THEO VTCV
                                Select * From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                                Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                      and ma_kpi in ('HCM_TL_CSKH_001')
                                      and to_truong_pho = 1
                                      and MA_VTCV = nv.MA_VTCV )
			Group by THANG, MA_PB, MA_TO, MA_NV, MA_VTCV
         ) nv
    Left join
        (
            Select MA_TO, sum(SO_GIAO)SO_GIAO, sum(SO_THUCHIEN)SO_THUCHIEN
            From khanhtdt_ttkd.TONGHOP_BSC_KPI_2024
            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and ma_kpi = 'HCM_TL_CSKH_001'
                  and loai = 1
            Group by MA_TO
         ) b
    On nv.MA_TO = b.MA_TO
    Where b.SO_THUCHIEN is not null
);
Commit;

--========== SỐ LƯỢNG VỊ TRÍ PGĐ PHỤ TRÁCH TỔ
--Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_TL_CSKH_001') and loai = 3;
--Delete From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_TL_CSKH_001') and loai = 3;
Insert Into TONGHOP_BSC_KPI_2024
(   THANG, LOAI, LOAI_KPI, MA_KPI, TEN_KPI, PHUTRACH
    , MA_PB, MA_NV, MA_VTCV
    , SO_GIAO, SO_THUCHIEN
)
(   --===== SAN LUONG PHO GIAM DOC PHU TRACH TO
    Select THANG, (3)LOAI, 'KPI_PB' LOAI_KPI, 'HCM_TL_CSKH_001' MA_KPI, ('Tỷ lệ chạm khách hàng (Dịch vụ CA-IVAN và Tên miền)')TEN_KPI, ('TO')PHUTRACH
		   , MA_PB, MA_NV, MA_VTCV
           , sum(SO_GIAO)SO_GIAO, sum(SO_THUCHIEN)SO_THUCHIEN
    From (
            Select a.THANG, a.MA_PB, a.MA_TO, a.MA_NV, a.MA_VTCV
                   , b.SO_GIAO, b.SO_THUCHIEN
            From (	--===== MA_NV PHÓ GIÁM ĐỐC PHỤ TRÁCH TỔ
                    Select thang, ma_pb, ma_to, ma_nv, ma_vtcv --, phutrach
                    From ttkd_bsc.blkpi_dm_to_pgd a
                    where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') 
                          and ma_kpi = 'HCM_TL_CSKH_001'
                          and upper(phutrach) = 'TO'
                          and exists (  --=== LẤY VỊ TRÍ PGĐ TRONG BẢNG DANH MỤC
                                        Select * From ttkd_bsc.blkpi_danhmuc_kpi_vtcv
                                        Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                              and ma_kpi = 'HCM_TL_CSKH_001'
                                              and GIAMDOC_PHOGIAMDOC = 1
                                              and ma_vtcv = a.ma_vtcv )
                    Group by thang, ma_pb, ma_to, ma_nv, ma_vtcv
                 ) a
            Left join
                (   
                    Select MA_TO, sum(SO_GIAO)SO_GIAO, sum(SO_THUCHIEN)SO_THUCHIEN
                    From khanhtdt_ttkd.TONGHOP_BSC_KPI_2024
                    Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                          and ma_kpi = 'HCM_TL_CSKH_001'
                          and loai = 1
                    Group by MA_TO
                ) b
            On a.MA_TO = b.MA_TO
         )
    Where SO_THUCHIEN is not null
    Group by THANG, MA_PB, MA_NV, MA_VTCV
);
Commit;
--====================================================================================================--