--=== Số lượng công tác nghiệp vụ, hậu mãi, CSKH - HCM_SL_CSKHH_004
--=== Bắt đầu từ tháng 202411 chỉ còn vị trí công việc của P.ONLINE

-- DỮ LIỆU GỐC -- của HỘI TỔ PM
Select count(*) From ttkdhcm_ktnv.yckh_bsc_nvnv Where to_number(to_char(ngayxl, 'yyyymm')) = to_char(trunc(sysdate, 'month')-1, 'yyyymm'); --8957
-- Số lượng công tác nghiệp vụ,  hậu mãi, CSKH
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Số lượng công tác nghiệp vụ, hậu mãi, CSKH';  -- bắt đầu từ tháng 202411 không còn KHDN
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_SL_CSKHH_004');                             -- bắt đầu từ tháng 202411 không còn KHDN
--=== KIEM TRA VTCV THEO MA_KPI
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004';
Select * From ttkd_bsc.nhanvien
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD'
      and ma_vtcv in ('VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_16.1','VNP-HNHCM_KDOL_16.2','VNP-HNHCM_KDOL_16.3'); --27 nv 1 nv tinh_bsc = 0 => 28 nv tinh_bsc = 1
Select * From ttkd_bsc.bangluong_kpi Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004'; -- 28 nv

--====================================================================================================--
--===== CHI TIẾT
Select * From ttkd_bsc.ktdt_ct_bsc_xl_nghievu_cskh Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm'); -- 9714
Delete From ttkd_bsc.ktdt_ct_bsc_xl_nghievu_cskh Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm');
Insert into ttkd_bsc.ktdt_ct_bsc_xl_nghievu_cskh
(   THANG, ID_YCKH, NGAYGOIVAO, SDTIN, SDTLH, TENKHGOIVAO, NOIDUNG, MA_TB, TEN_PB_NHAN, TEN_TO_NHAN, TEN_NV_NHAN, MA_NV, MA_TO, MA_PB, HOANTAT, NGAYXL, MA_GD   )
    Select cast(to_char(trunc(sysdate, 'month')-1, 'yyyymm') as number(6)) thang, a.id_yckh, cast(a.ngaygoivao as date) ngaygoivao, a.sdtin
           , substr(trim(a.sdtlh),1,40)sdtlh
           , a.tenkhgoivao, a.noidung, a.thuebao ma_tb
           , nv.ten_pb ten_pb_nhan, nv.ten_to ten_to_nhan, nv.ten_nv ten_nv_nhan
           , a.nv_nhan_manv_hrm ma_nv, nv.ma_to, nv.ma_pb
		   , a.hoantat, a.ngayxl	-- ==> Hoi xu ly lai tu bsc thang 05/2024
           , a.ma_gd
           --, KHIEUNAI_ID, MA_KN, row_number() over (partition by noidung order by ID_YCKH desc) rnk
    From ttkdhcm_ktnv.yckh_bsc_nvnv a
    Left join ttkd_bsc.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD' and a.nv_nhan_manv_hrm = nv.ma_nv
    Where to_char(trunc(ngayxl), 'yyyymm') = to_char(trunc(sysdate, 'month')-1, 'yyyymm')		-- ==> Hoi xu ly lai tu bsc thang 202405
;
Commit;
Select ID_YCKH From ttkd_bsc.ktdt_ct_bsc_xl_nghievu_cskh Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') Group by ID_YCKH Having count(*)>1;
Select ID_YCKH From ttkd_bsc.ktdt_ct_bsc_xl_nghievu_cskh Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_nv is null Group by ID_YCKH Having count(*)>1;
--====================================================================================================--


--==================================================--
--===== UP ID88 - Lưu ý dấu ' thì them 1 dau ' => '' không phải "
-- tham khao tu Hoc
Select THANG, TEN_PB, TEN_TO, TEN_NV, TEN_VTCV, count(ID_YCKH)SL
From (
        Select a.THANG, a.ID_YCKH
                , nv.MA_PB, nv.TEN_PB
                , nv.MA_TO, nv.TEN_TO
                , a.MA_NV, nv.TEN_NV, nv.ma_vtcv, nv.ten_vtcv
                , a.MA_TB, to_char(a.NGAYGOIVAO, 'dd/mm/yyyy') ngay_yc
                , to_char(a.ngayxl, 'dd/mm/yyyy') ngay_xuly, a.HOANTAT, a.TENKHGOIVAO, a.SDTLH
        From ttkd_bsc.ktdt_ct_bsc_xl_nghievu_cskh a
        Left join ttkd_bsc.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD' and nv.ma_nv = a.ma_nv
        Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
              --and nv.ma_vtcv in ('VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_16.1','VNP-HNHCM_KDOL_16.2','VNP-HNHCM_KDOL_16.3')  
    ) nv
Group by THANG, TEN_PB, TEN_TO, TEN_NV, TEN_VTCV
Order by TEN_TO, TEN_VTCV, TEN_NV
;
-- Khanh
Select *
From (
        Select a.THANG, nv.MA_PB, nv.TEN_PB, nv.MA_TO, nv.TEN_TO, a.MA_NV, nv.TEN_NV, nv.MA_VTCV, a.SO_THUCHIEN
        From TONGHOP_BSC_KPI_2024 a
        Left join ttkd_bsc.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD' and nv.ma_nv = a.ma_nv
        Where a.ma_kpi = 'HCM_SL_CSKHH_004'
              and a.loai = 1
              and nv.ma_vtcv in ('VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_16.1','VNP-HNHCM_KDOL_16.2','VNP-HNHCM_KDOL_16.3')
        Order by nv.TEN_TO, nv.MA_VTCV, nv.TEN_NV
	 )
;
--==================================================--