--===== Muc dich la Insert vào bàng bangluong_kpi
--===== theo VTCV và MA_KPI
-- Số lượng công tác nghiệp vụ,  hậu mãi, CSKH
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = 202412 and ten_kpi like 'Thực hiện đổi sim 4G';
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = 202412 and ma_kpi in ('HCM_TB_SIM4G_002');
--=== KIEM TRA VTCV THEO MA_KPI - KIỂM TRA ĐẠ ĐỦ VỊ TRÍ CV NHƯ THEO VB HAY CHƯA
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = 202412 and ma_kpi = 'HCM_TB_SIM4G_002';
Select * From ttkd_bsc.nhanvien Where thang = 202412 and donvi = 'TTKD' and ma_vtcv in ('VNP-HNHCM_BHKV_22','VNP-HNHCM_BHKV_27','VNP-HNHCM_BHKV_28'); --198 nv
--===
Select a.*, nv.ma_nv, nv.ten_nv, nv.tinh_bsc
From ( Select THANG, MA_KPI, MA_NV, TEN_NV, TEN_VTCV, GIAO From ttkd_bsc.bangluong_kpi Where thang = 202412 and MA_KPI = 'HCM_TB_SIM4G_002' Order by ma_pb, ma_vtcv ) a
Left join ttkd_bsc.nhanvien nv On nv.thang = 202412 and nv.donvi = 'TTKD' and nv.ma_nv = a.ma_nv
Order by nv.tinh_bsc;

--=== KIEM SO GIAO TREN ID372
Select * From ttkdhcm_ktnv.ID372_GIAO_C2_CHOTTHANG Where thang = 202412;
Select * From ttkdhcm_ktnv.ID372_GIAO_C2_CHOTTHANG Where thang = 202412 and bo_dau(TEN_KPI) = '3.CT DOI SIM 4G';
Select substr(ten_to,1,3) From ttkdhcm_ktnv.ID372_GIAO_C2_CHOTTHANG Where thang = 202412 and bo_dau(TEN_KPI) = '3.CT DOI SIM 4G' Group by substr(ten_to,1,3);
Select * From ttkdhcm_ktnv.ID372_GIAO_C2_CHOTTHANG Where thang = 202412 and bo_dau(TEN_KPI) = '3.CT DOI SIM 4G' and ten_to like 'NV%';
Select * From ttkdhcm_ktnv.ID372_GIAO_C2_CHOTTHANG Where thang = 202412 and bo_dau(TEN_KPI) = '3.CT DOI SIM 4G' and ten_to like 'TT%';
--====================================================================================================--
--===== CẬP NHẬT BẢNG LƯƠNG KPI THEO VỊ TRÍ CÔNG VIỆC
--===== Select * From bangluong_kpi where thang = 202409;
--===== MÃ KPI = HCM_TB_SIM4G_002 ==> dành cho nhân viên
--====================================================================================================--
Select * From ttkd_bsc.bangluong_kpi Where thang = 202412 and MA_KPI = 'HCM_TB_SIM4G_002' Order by ma_pb, ma_vtcv;  --198 nv
--=====
Update ttkd_bsc.bangluong_kpi a
	Set a.GIAO = null
Where a.THANG = 202412
	  and a.MA_KPI = 'HCM_TB_SIM4G_002'
	  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where THANG = 202412
						  and MA_KPI in ('HCM_TB_SIM4G_002')						-- <== LƯU Ý MÃ KPI
					      and MA_VTCV = a.MA_VTCV );
Commit;
--=== SO_GIAO CÁ NHÂN
Update ttkd_bsc.bangluong_kpi a
    Set a.GIAO
        = ( 
            Select distinct SOGIAO
            From ttkdhcm_ktnv.ID372_GIAO_C2_CHOTTHANG
            Where thang = 202412
                  and bo_dau(TEN_KPI) = '3.CT DOI SIM 4G'
                  and TEN_TO like 'NV%'                                 --=== Lưu ý cá nhân
                  and MA_NV = a.MA_NV
          )
Where a.THANG = 202412
	  and a.MA_KPI = 'HCM_TB_SIM4G_002'
	  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where THANG = 202412
						  and MA_KPI in ('HCM_TB_SIM4G_002')						-- <== LƯU Ý MÃ KPI
                          and GIAMDOC_PHOGIAMDOC is null
					      and MA_VTCV = a.MA_VTCV );
Commit;
--=== SO_GIAO TỔ TRƯỞNG
Update ttkd_bsc.bangluong_kpi a
    Set a.GIAO
        = ( 
            Select distinct SOGIAO
            From ttkdhcm_ktnv.ID372_GIAO_C2_CHOTTHANG
            Where thang = 202412
                  and bo_dau(TEN_KPI) = '3.CT DOI SIM 4G'
                  and TEN_TO like 'TT%'                                 --=== Lưu ý Tổ trưởng
                  and MA_TO = a.MA_TO
          )
Where a.THANG = 202412
	  and a.MA_KPI = 'HCM_TB_SIM4G_002'
	  and exists (	Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv
					Where THANG = 202412
						  and MA_KPI in ('HCM_TB_SIM4G_002')						-- <== LƯU Ý MÃ KPI
                          and TO_TRUONG_PHO = 1
					      and MA_VTCV = a.MA_VTCV );
Commit;
--====================================================================================================--
Select * From TTKD_BSC.BLKPI_DANHMUC_KPI Where thang = 202412 and ma_kpi = 'HCM_TB_SIM4G_002';
--===
Update TTKD_BSC.BLKPI_DANHMUC_KPI
    Set giao = 1, thuchien = 1
Where thang = 202412
      and upper(NGUOI_XULY) = 'KHANH'
      and ma_kpi in ('HCM_TB_SIM4G_002');
Commit;
--====================================================================================================--
