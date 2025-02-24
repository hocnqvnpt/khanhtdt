--=== TEST LUONG DON GIA = 0 tất cả => OK
Select a.ma_nv, TONGTIEN, LUONG_DONGIA_NGHIEPVU, TONGTIEN-LUONG_DONGIA_NGHIEPVU SS_TT
From ( Select MA_NV, TONGTIEN From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_SL_CSKHH_004' and MA_VTCV in ('VNP-HNHCM_KDOL_16.3','VNP-HNHCM_KDOL_22') ) a
Left Join ( Select MA_NV, LUONG_DONGIA_NGHIEPVU From ttkd_bsc.bangluong_dongia_202501 Where LUONG_DONGIA_NGHIEPVU > 0 ) b on a.ma_nv = b.ma_nv
 
 