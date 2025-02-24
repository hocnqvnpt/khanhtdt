--============================================================================================================================
--=== TỶ LỆ NGHIỆP VỤ XỬ LÝ QUÁ HẠN
--=== Theo vb301 BSC ban hành - Tỷ lệ nghiệp vụ xử lý quá hạn:
--=== Công thức = Số lượng ID nghiệp vụ thực hiện quá hạn & tồn chưa xử lý quá hạn / Tổng YCKH trên ID163-164
--=== * Tồn chưa xử lý quá hạn = Tổng YCKH trên ID163-164 - Số lượng ID nghiệp vụ thực hiện - Số lượng ID nghiệp vụ KH hẹn
--=== Chỉ tiêu này Hội và Duyên đã thống nhất sử dụng NGÀY RA PHIẾU để tính.
--=== Cho nên Số lượng ID nghiệp vụ thực hiện chỉ tiêu này sẽ khác Số lượng ID nghiệp vụ thực hiện chỉ tiêu CSKHH_004
--=== THEO BUOI HOP NGÀY 28/11/2024 - SỐ GIAO TÍNH THEO MỨC ĐỘ HOÀN THÀNH 100%
--============================================================================================================================
--===
-- Số lượng công tác nghiệp vụ,  hậu mãi, CSKH
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = 202501 and ten_kpi like 'Tỷ lệ nghiệp vụ xử lý quá hạn';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = 202501 and ma_kpi in ('HCM_SL_BHOL_001');
--=== KIEM TRA VTCV THEO MA_KPI - KIỂM TRA ĐẠ ĐỦ VỊ TRÍ CV NHƯ THEO VB HAY CHƯA
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = 202501 and ma_kpi = 'HCM_SL_BHOL_001';
Select * from TTKD_BSC.nhanvien
where thang = 202501 and donvi = 'TTKD'
      and ma_vtcv in ('VNP-HNHCM_KDOL_16.3','VNP-HNHCM_KDOL_22','VNP-HNHCM_KDOL_24.1','VNP-HNHCM_KDOL_18','VNP-HNHCM_KDOL_23'); --13 nv tinh_bsc = 1
Select * From ttkd_bsc.blkpi_dm_to_pgd@ttkddb where thang = 202501 and ma_pb = 'VNP0703000';

--====================================================================================================--
--===== CẬP NHẬT BẢNG LƯƠNG KPI THEO VỊ TRÍ CÔNG VIỆC
--===== Select * From bangluong_kpi
--===== MÃ KPI = HCM_SL_BHOL_001 ==> dành cho nhân viên
--===== THEO BUOI HOP NGÀY 28/11/2024 - SỐ GIAO TÍNH THEO MỨC ĐỘ HOÀN THÀNH 100%
--====================================================================================================--
Select * From ttkd_bsc.bangluong_kpi Where thang = 202501 and MA_KPI = 'HCM_SL_BHOL_001' Order by ma_pb, ma_vtcv;
--=====
Update ttkd_bsc.bangluong_kpi a
	Set a.CHITIEU_GIAO = 100, a.GIAO = null, a.TYTRONG = 10, a.DONVI_TINH = '%'
Where a.THANG = 202501
	  and a.MA_KPI = 'HCM_SL_BHOL_001'
	  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where THANG = 202501
						  and MA_KPI in ('HCM_SL_BHOL_001')						-- <== LƯU Ý MÃ KPI
						  and GIAMDOC_PHOGIAMDOC is null						-- <== LƯU Ý VỊ TRÍ CẬP NHẬT
					      and MA_VTCV = a.MA_VTCV );
Commit;
--=====
Update ttkd_bsc.bangluong_kpi a
	Set a.CHITIEU_GIAO = 100, a.GIAO = null, a.TYTRONG = 10, a.DONVI_TINH = '%'
Where a.THANG = 202501
	  and a.MA_KPI = 'HCM_SL_BHOL_001'
	  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where THANG = 202501
						  and MA_KPI in ('HCM_SL_BHOL_001')						-- <== LƯU Ý MÃ KPI
						  and TO_TRUONG_PHO = 1									-- <== LƯU Ý VỊ TRÍ CẬP NHẬT
					      and MA_VTCV = a.MA_VTCV );
Commit;
--=====
Update ttkd_bsc.bangluong_kpi a
	Set a.CHITIEU_GIAO = 100, a.GIAO = null, a.TYTRONG = 10, a.DONVI_TINH = '%'
Where a.THANG = 202501
	  and a.MA_KPI = 'HCM_SL_BHOL_001'
      and a.MA_NV = 'VNP017072'             -- Hồng Duyên
	  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where THANG = 202501
						  and MA_KPI in ('HCM_SL_BHOL_001')						-- <== LƯU Ý MÃ KPI
						  and GIAMDOC_PHOGIAMDOC = 1							-- <== LƯU Ý VỊ TRÍ CẬP NHẬT
					      and MA_VTCV = a.MA_VTCV );
Commit;
--====================================================================================================--
Select * From TTKD_BSC.BLKPI_DANHMUC_KPI Where thang = 202501 and ma_kpi = 'HCM_SL_BHOL_001';
--===
Update TTKD_BSC.BLKPI_DANHMUC_KPI
    Set giao = 1, thuchien = 0, mucdo_hoanthanh = 1
Where thang = 202501
      and NGUOI_XULY = 'Khanh'
      and ma_kpi in ('HCM_SL_BHOL_001');
Commit;
--====================================================================================================--



--====================================================================================================--
--Drop Table SO_GIAO_TONG;
--Create Table SO_GIAO_TONG as (
--    Select (202501)THANG, 'HCM_SL_BHOL_001' ma_kpi, nv.ma_nv, nv.ma_to, nv.ma_pb
--		   , a.*
--    From (  select nv_nhan_id, count(*)sl
--			from ttkdhcm_ktnv.yckh_chuyenxl a
--            where a.tientrinhxl>0
--                  and a.nv_nhan_id in (select nhanvien_id from ttkdhcm_ktnv.yckh_nvob_cskh1 where tinh_sanluong=1)
--                  and a.ngayxl >= trunc(add_months(trunc(sysdate), -1),'mm')
--                  and a.ngayxl < trunc(add_months(trunc(sysdate), -0),'mm')
--            group by a.nv_nhan_id
--         ) a
--    Left join ttkd_bsc.nhanvien nv On thang = 202501 and donvi = 'TTKD' and a.NV_NHAN_ID = nhanvien_id
--);
--===    

