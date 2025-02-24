
--====================================================================================================--
--========== HCM_CL_TNGOI_005 ĐỔI (vb235) HCM_CL_TNGOI_006 ==========--
--====================================================================================================--

--=== SO LIEU NAY DO KHÁNH lấy từ IPCC về
SELECT a.id OB_ID, a.ttkd, a.donvi, a.team, a.username, a.ktv, a.chuongtrinh_ob
	   , a.thuebao, a.mang, a.trangthai
	   , to_date(a.thoidiem_thuc_hien, 'dd:mm:yyyy') thoidiem_thuc_hien
	   , a.thoidiem_bat_dau
	   , a.thoidiem_traloi
	   , a.thoidiem_ketthuc
	   , a.thoigian_cuocgoi, a.thoigian_dochuong, a.thoigian_hang_doi
	   , a.thoigian_giumay, a.thoigian_dam_thoai
FROM TTKDHCM_KTNV.ob_ipcc_buff_514 a;


--====================================================================================================--
--===== CHI TIẾT =====
--===== IPCC SỐ LIỆU LẤY TỪ KHÁNH CUNG CẤP
--====================================================================================================--
Select * From KHANHTDT_TTKD.kq_ct_ipcc_cskhts_talktime Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm'); -- 2110
--Select * From KHANHTDT_TTKD.kq_ct_ipcc_cskhts_talktime Where thang = ;
Delete From KHANHTDT_TTKD.kq_ct_ipcc_cskhts_talktime Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm');
Commit;
Insert Into KHANHTDT_TTKD.kq_ct_ipcc_cskhts_talktime
    with --=== Nhân vien OB
		nv_ipcc as
			(	
                Select a.nguoidung_id, a.user_ipcc, b.nhanvien_id, c.ma_nv
				From admin.nguoidung_ipcc@dataguard a
				Join admin.v_nguoidung@dataguard b on a.nguoidung_id = b.nguoidung_id
				Join admin.v_nhanvien@dataguard c on b.nhanvien_id = c.nhanvien_id
			)
		, nv_ipcc2 as
			(	
                Select b.nguoidung_id, b.ma_nd, c.nhanvien_id, c.ma_nv
				From admin.v_nguoidung@dataguard b
				Join admin.v_nhanvien@dataguard c on b.nhanvien_id = c.nhanvien_id
			)
		--=== SỐ LƯỢNG CUỘC GỌI OB CSKH TS THÀNH CÔNG VÀ TỪ 10s
		, ipcc as (   
				Select *
				From (  
                        Select a.*, row_number() Over(Partition by a.ob_id, a.username Order by a.thoidiem_thuc_hien desc)row_num
						From (  --=== SO LIEU NAY DO KHÁNH lấy từ IPCC về đưa lên ID514 web123
								SELECT a.id OB_ID, a.ttkd, a.donvi, a.team, a.username, a.ktv, a.chuongtrinh_ob
									   , a.thuebao, a.mang, a.trangthai
									   , to_date(a.thoidiem_thuc_hien, 'dd:mm:yyyy') thoidiem_thuc_hien
									   , a.thoidiem_bat_dau
									   , a.thoidiem_traloi
									   , a.thoidiem_ketthuc
									   , a.thoigian_cuocgoi, a.thoigian_dochuong, a.thoigian_hang_doi
									   , a.thoigian_giumay, a.thoigian_dam_thoai
                                --Select *
								FROM TTKDHCM_KTNV.ob_ipcc_buff_514 a
							) a
						Where TRANGTHAI = 'SUCCESS'
							  and thoigian_dam_thoai >= 10
							  and to_char(trunc(thoidiem_thuc_hien), 'yyyymm') = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
					 )
				Where row_num = 1
    )
    Select cast(to_char(trunc(sysdate, 'month')-1, 'yyyymm') as number(6)) thang, a.ob_id, a.ttkd, a.team, a.chuongtrinh_ob
           , a.thuebao, a.mang, a.trangthai, a.thoidiem_thuc_hien, a.thoidiem_bat_dau, a.thoidiem_traloi, a.thoidiem_ketthuc
           , a.thoigian_cuocgoi, a.thoigian_dochuong, a.thoigian_hang_doi, a.thoigian_giumay, a.thoigian_dam_thoai
           , a.donvi, a.username, a.ktv
           , (case when c.nhanvien_id is not null then c.nhanvien_id else d.nhanvien_id end) nhanvien_id
		   , (case when c.ma_nv is not null then c.ma_nv else d.ma_nv end) ma_nv
		   , (case when nv.ma_to is not null then nv.ma_to else nv2.ma_to end) ma_to
		   , (case when nv.ma_pb is not null then nv.ma_pb else nv2.ma_pb end) ma_pb
           , ('ID514 web123 ' || sysdate )NGUON
    From ipcc a
    Left join nv_ipcc c on a.username = c.user_ipcc
	Left join nv_ipcc2 d on a.username = d.ma_nd
    Left join TTKD_BSC.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD' and c.ma_nv = nv.ma_nv
	Left join TTKD_BSC.nhanvien nv2 On nv2.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv2.donvi = 'TTKD' and d.ma_nv = nv2.ma_nv
;
Commit;
--====================================================================================================--
--==== KIEM TRA TRUNG
Select OB_ID From KHANHTDT_TTKD.kq_ct_ipcc_cskhts_talktime Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') Group by OB_ID Having count(*)>1;
--==== KIEM TRA DU NGAY THUC HIEN HAY KHONG => không có các ngày t7 và cn và ngày nghĩ lễ
Select thoidiem_thuc_hien, count(*)SL, sum(thoigian_dam_thoai)TG_DT, Round(sum(thoigian_dam_thoai)/60,2)TG_PHUT
From KHANHTDT_TTKD.kq_ct_ipcc_cskhts_talktime
Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm')
Group by thoidiem_thuc_hien Order by thoidiem_thuc_hien;
--=== KIEM TRA MA_NV not null => OK
Select ma_nv From KHANHTDT_TTKD.kq_ct_ipcc_cskhts_talktime Where thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and ma_nv is null; -- 2758
--====================================================================================================--


--====================================================================================================--
--===== UP ID88 - CHI TIET - Lưu ý dấu ' thì them 1 dau ' => '' không phải " 
Select * From (
	Select a.thang, a.OB_ID, a.THUEBAO
		   , to_char(a.THOIDIEM_THUC_HIEN,'dd/mm/yyyy')THOIDIEM_THUC_HIEN
		   , a.THOIDIEM_BAT_DAU, a.THOIDIEM_TRALOI, a.THOIDIEM_KETTHUC
		   , a.THOIGIAN_DOCHUONG, a.THOIGIAN_HANG_DOI, a.THOIGIAN_GIUMAY
           , a.THOIGIAN_DAM_THOAI THOIGIAN_DAMTHOAI_GIAY
		   , a.TRANGTHAI, a.USERNAME
		   , nv.MA_PB, nv.ten_pb
		   , nv.ma_to, nv.ten_to
		   , a.ma_nv, nv.ten_nv
	From KHANHTDT_TTKD.kq_ct_ipcc_cskhts_talktime a
	Left join TTKD_BSC.nhanvien nv On nv.thang = to_char(trunc(sysdate, 'month')-1, 'yyyymm') and nv.donvi = 'TTKD' and nv.ma_nv = a.ma_nv
	Order by nv.ten_pb, nv.ten_to, nv.ten_nv
)
;
--====================================================================================================--