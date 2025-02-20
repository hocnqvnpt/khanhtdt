
/* ----- DM Nghiệp vụ trong file SBH (ONEBSS) ----- */
Select loaihd_id, tthd_id, ten_loaihd from tuyenngo.sbh_202501_CT Group by loaihd_id, tthd_id, ten_loaihd
Union
Select loaihd_id, tthd_id, ten_loaihd From tuyenngo.sbh_202412_CT Group by loaihd_id, tthd_id, ten_loaihd
Union
Select loaihd_id, tthd_id, ten_loaihd From tuyenngo.sbh_202411_CT Group by loaihd_id, tthd_id, ten_loaihd
Union
Select loaihd_id, tthd_id, ten_loaihd From tuyenngo.sbh_202409_CT Group by loaihd_id, tthd_id, ten_loaihd
Union
Select loaihd_id, tthd_id, ten_loaihd From tuyenngo.sbh_202408_CT Group by loaihd_id, tthd_id, ten_loaihd
Union
Select loaihd_id, tthd_id, ten_loaihd From tuyenngo.sbh_202407_CT Group by loaihd_id, tthd_id, ten_loaihd
Union
Select loaihd_id, tthd_id, ten_loaihd From tuyenngo.sbh_202406_CT Group by loaihd_id, tthd_id, ten_loaihd
Union
Select loaihd_id, tthd_id, ten_loaihd From tuyenngo.sbh_202405_CT Group by loaihd_id, tthd_id, ten_loaihd
Union
Select loaihd_id, tthd_id, ten_loaihd From tuyenngo.sbh_202404_CT Group by loaihd_id, tthd_id, ten_loaihd
Union
Select loaihd_id, tthd_id, ten_loaihd From tuyenngo.sbh_202403_CT Group by loaihd_id, tthd_id, ten_loaihd
Union
Select loaihd_id, tthd_id, ten_loaihd From tuyenngo.sbh_202402_CT Group by loaihd_id, tthd_id, ten_loaihd
Union
Select loaihd_id, tthd_id, ten_loaihd From tuyenngo.sbh_202401_CT Group by loaihd_id, tthd_id, ten_loaihd
Order by ten_loaihd;