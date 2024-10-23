--===== MỤC DÍCH LÀ CẬP NHẬT VÀO BÀNG LUONG KPI
--===== THEO VTCT VÀ MA KPI
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ten_kpi like 'Tỷ lệ thời gian Talktime tiếp nhận cuộc gọi_OB GHTT'; --202406 => HCM_CL_TNGOI_004
Select * from TTKD_BSC.blkpi_danhmuc_kpi where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi like 'HCM_CL_TNGOI_004'; -- => OK
Select * from TTKD_BSC.blkpi_danhmuc_kpi_vtcv where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi in ('HCM_CL_TNGOI_004'); -- => NV OB GHTT (P.ONL va KHDN) => OK
--=== Văn bản P.NS tháng 08/2024, mã kpi HCM_CL_TNGOI_004 không tính cho Tổ trưởng và PGĐ phụ trách => Không cần kiểm tra

--====================================================================================================--
Select * From ttkd_bsc.ktdt_ct_ipcc_obghtt_talktime where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm');
Select td_th, count(*)SL, sum(TG_DT)TG_DT, Round(sum(TG_DT)/60,2)TG_PHUT
From ttkd_bsc.ktdt_ct_ipcc_obghtt_talktime Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
Group by td_th Order by td_th;
--====================================================================================================--


--====================================================================================================--
--=== TONGHOP_BSC_KPI_2024 - MA KPI = 'HCM_CL_TNGOI_004'
--=== TG_DT (giây) ==> ĐỔI SO_THUCHIEN (phút)
--====================================================================================================--
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TNGOI_004' Order by loai, ma_pb, ma_to, ma_nv;
Delete From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TNGOI_004';
Commit;
--================================================== SAN LUONG VI TRI CÁ NHÂN
Insert Into TONGHOP_BSC_KPI_2024
--(   THANG, MA_KPI, TEN_KPI, NGAYCONG_CHUAN, SO_GIAO, LOAI, LOAI_KPI, MA_PB, MA_TO, MA_NV, SO_THUCHIEN  )
(   THANG, MA_KPI, TEN_KPI, LOAI, LOAI_KPI, MA_PB, MA_TO, MA_NV, MA_VTCV, TINH_BSC, SO_THUCHIEN  )
(   --===== SAN LUONG CA NHAN
	Select THANG, 'HCM_CL_TNGOI_004' ma_kpi, 'Tỷ lệ thời gian Talktime tiếp nhận cuộc gọi_OB GHTT' TEN_KPI
		   , (1)LOAI, ('KPI_NV')LOAI_KPI, MA_PB, MA_TO, MA_NV, MA_VTCV, TINH_BSC							-- <= LUU Y SL CA NHAN = MA_PB, MA_TO, MA_NV
		   , SO_THUCHIEN
	From (
            Select a.THANG, nv.MA_PB, nv.MA_TO, a.MA_NV, nv.MA_VTCV, nv.TINH_BSC
                   , a.SO_THUCHIEN
            From (
                    Select THANG, MA_NV
                           , Round( sum(TG_DT)/60, 2) SO_THUCHIEN                                         	-- <= LƯU Ý TÍNH RA KQ LÀ PHÚT
                    From ttkd_bsc.ktdt_ct_ipcc_obghtt_talktime
                    Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                          and MA_NV is not null
                    Group by THANG, MA_NV
                 ) a
            Left join ttkd_bsc.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and donvi = 'TTKD' and nv.MA_NV = a.MA_NV
         )
);
Commit;
--===== Them 1 NV KHÔNG CÓ trong bang tong hop ma co DS bh online MA_NV = CTV087580
Insert Into TONGHOP_BSC_KPI_2024
(   THANG, MA_KPI, TEN_KPI, LOAI, LOAI_KPI, MA_PB, MA_TO, MA_NV, MA_VTCV, TINH_BSC, SO_THUCHIEN  )
(	Select (202409) THANG, 'HCM_CL_TNGOI_004' ma_kpi, 'Tỷ lệ thời gian Talktime tiếp nhận cuộc gọi_OB GHTT' TEN_KPI
           , (1)LOAI, ('KPI_NV')LOAI_KPI, 'VNP0703000' MA_PB, 'VNP0703005' MA_TO, 'CTV087580' MA_NV, 'VNP-HNHCM_KDOL_15' MA_VTCV, (0)TINH_BSC
           , 0 SO_THUCHIEN
    From Dual
);
Commit;
--===== UPDATE THEM SO_THUC cua P.BHONL VAO TONGHOP_BSC_KPI_2024
Update TONGHOP_BSC_KPI_2024 a
	Set a.SO_THUCHIEN
        = ( Select distinct TONG_THUCHIEN
            From (  
                    Select a.ma_nv, a.SL, b.SO_THUCHIEN, Round(nvl(a.SL,0) + nvl(b.SO_THUCHIEN,0),2)TONG_THUCHIEN
                    From ( Select distinct MA_NV, SL From A_SL_ONLINE ) a
                    Left join
                        (   Select MA_NV, SO_THUCHIEN
                            From TONGHOP_BSC_KPI_2024
                            Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                            and ma_kpi in ('HCM_CL_TNGOI_004')
                            and loai = 1
                         ) b
                    On a.ma_nv = b.ma_nv
                 )
            Where ma_nv = a.ma_nv
           )
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
      and a.ma_kpi = 'HCM_CL_TNGOI_004'
      and a.loai = 1
      and exists (Select 1 From A_SL_ONLINE Where ma_nv = a.ma_nv );
Commit;
--===== UPDATE NGÀY CÔNG CHUẨN VÀ SỐ GIAO
Update TONGHOP_BSC_KPI_2024 a
	Set a.NGAYCONG_CHUAN = 19, a.SO_GIAO = (180*19)
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and a.ma_kpi = 'HCM_CL_TNGOI_004' and a.loai = 1;
Commit;
--===== UPDATE TỶ LỆ HOÀN THÀNH CÁ NHÂN
Update TONGHOP_BSC_KPI_2024 a
    Set a.TYLE = Round( (a.SO_THUCHIEN*100)/a.SO_GIAO, 2)
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and a.ma_kpi = 'HCM_CL_TNGOI_004' and a.loai = 1;
Commit;
--===== UPDATE MỨC ĐỘ HOÀN THÀNH
Update TONGHOP_BSC_KPI_2024 a
    Set a.MUCDO_HT
         = (Case when TYLE >= 100 then 120
                 when (TYLE >= 80 and TYLE < 100) then 100 + (TYLE-80)
                 when (TYLE >= 50 and TYLE < 80)  then  Round( (100*TYLE)/100, 2)
                 when TYLE < 50 then 0
            end)     
Where a.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and a.ma_kpi = 'HCM_CL_TNGOI_004' and a.loai = 1;
Commit;
--================================================== SAN LUONG VI TRI TO TRUONG
--=== Văn bản P.NS tháng 09/2024, mã kpi HCM_CL_TNGOI_004 không tính cho Tổ trưởng và PGĐ phụ trách => Không cần kiểm tra
Insert Into TONGHOP_BSC_KPI_2024
(   THANG, MA_KPI, TEN_KPI, LOAI, LOAI_KPI, MA_PB, MA_TO, MA_NV, SO_THUCHIEN  )
(   --===== SAN LUONG TO
	Select THANG, 'HCM_CL_TNGOI_004' ma_kpi, 'Tỷ lệ thời gian Talktime tiếp nhận cuộc gọi_OB GHTT' TEN_KPI
		   , (2)LOAI, ('KPI_TO')LOAI_KPI, MA_PB, MA_TO, (NULL)MA_NV, SO_THUCHIEN                            -- <== LUU Y SL TO = MA_PB, MA_TO, (NULL)MA_NV

	From (  --=== TÍNH SỐ LƯỢNG TỔ TỪ SỐ LƯỢNG CÁ NHÂN
			Select THANG, MA_PB, MA_TO, sum(SO_THUCHIEN)SO_THUCHIEN
            From TONGHOP_BSC_KPI_2024 a
            Where THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                  and MA_KPI = 'HCM_CL_TNGOI_004'
                  and loai = 1
                  and tinh_bsc = 1
			Group by THANG, MA_PB, MA_TO
            Order by MA_PB, MA_TO
		 )
);
Commit;
--================================================== SAN LUONG VI TRI PGĐ
--=== Văn bản P.NS tháng 08/2024, mã kpi HCM_CL_TNGOI_004 không tính cho Tổ trưởng và PGĐ phụ trách => Không cần kiểm tra
Insert Into TONGHOP_BSC_KPI_2024
(   THANG, MA_KPI, TEN_KPI, LOAI, LOAI_KPI, MA_PB, MA_TO, MA_NV, SO_THUCHIEN  )
(   --===== SAN LUONG PHO GIAM DOC PHU TRACH TO
	Select THANG, 'HCM_CL_TNGOI_004' ma_kpi, 'Tỷ lệ thời gian Talktime tiếp nhận cuộc gọi_OB GHTT' TEN_KPI
		   , (3)LOAI, ('KPI_PB')LOAI_KPI, MA_PB, (NULL)MA_TO, MA_NV, SO_THUCHIEN                            -- <== LUU Y SL PGD = MA_PB, (NULL)MA_TO, MA_NV
		   
    From (	--=== TÍNH SỐ LƯỢNG PGĐ TỪ SỐ LƯỢNG TỔ
			Select thang, ma_pb, ma_nv, sum(SO_THUCHIEN)SO_THUCHIEN
			From (
					Select a.THANG, a.MA_PB, a.MA_TO, a.TEN_TO, a.MA_NV, a.TEN_NV, b.SO_THUCHIEN
					From (  
                            --===== Lấy MA_NV của PHÓ GIÁM ĐỐC PHỤ TRÁCH TỔ + THEO DANH MỤC MÃ KPI VỊ TRÍ CÔNG VIỆC
                            Select THANG, MA_PB, TEN_PB, MA_TO, TEN_TO, MA_NV, TEN_NV
							From ttkd_bsc.blkpi_dm_to_pgd@ttkddb a
							Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                  and dichvu is null  
								  and exists (	--=== LẤY MÃ TỔ THEO DANH MỤC KPI VỊ TRÍ CÔNG VIỆC
                                                Select 1
                                                From (
                                                        Select ma_to, ten_to
                                                        From ttkd_bsc.nhanvien nv
                                                        Where nv.thang = 202409 and nv.donvi = 'TTKD'
                                                              and exists (  Select MA_VTCV
                                                                            From TTKD_BSC.blkpi_danhmuc_kpi_vtcv
                                                                            where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                                                                  and ma_kpi in ('HCM_CL_TNGOI_004')					--== LƯU Ý MA KPI
                                                                                  and GIAMDOC_PHOGIAMDOC is null
                                                                                  and nv.ma_vtcv = ma_vtcv
                                                                         )
                                                        Group by ma_to, ten_to
                                                     )
                                                Where a.ma_to = ma_to
											 )
							Group by THANG, MA_PB, TEN_PB, MA_TO, TEN_TO, MA_NV, TEN_NV
							Order by MA_PB, MA_NV
						 ) a
					Left join
						(   --===== SỐ LƯỢNG MA_TO
                            Select THANG, MA_PB, MA_TO, sum(SO_THUCHIEN)SO_THUCHIEN
                            From TONGHOP_BSC_KPI_2024
                            Where THANG = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
                                  and MA_KPI = 'HCM_CL_TNGOI_004'
                                  and loai = 1
                                  and tinh_bsc = 1
                            Group by THANG, MA_PB, MA_TO
                            Order by MA_PB, MA_TO
						) b
					On a.ma_to = b.ma_to
					Order by a.MA_PB, a.MA_NV, a.MA_TO
				 )
			Group by thang, ma_pb, ma_nv
			Order by ma_pb, ma_nv
         )
);
Commit;
--========== TEST KQ NGẪU NHIÊN - CÁ NHÂN
Select * From TONGHOP_BSC_KPI_2024 Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_kpi = 'HCM_CL_TNGOI_004' and loai = 1 Order by loai, ma_pb, ma_to, ma_nv;
--====================================================================================================--