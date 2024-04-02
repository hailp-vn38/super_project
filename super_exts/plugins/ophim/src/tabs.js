async function tabs() {
  return Response.success([
    {
      title: "Phim mới cập nhật",
      url: "/danh-sach/phim-moi-cap-nhat",
    },
    {
      title: "Phim lẻ",
      url: "/v1/api/danh-sach/phim-le",
    },
    {
      title: "Phim bộ",
      url: "/v1/api/danh-sach/phim-bo",
    },

    {
      title: "Hoạt hình",
      url: "/v1/api/danh-sach/hoat-hinh",
    },
    {
      title: "TV Shows",
      url: "/v1/api/danh-sach/tv-shows",
    },
    {
      title: "Phim Vietsub",
      url: "/v1/api/danh-sach/phim-vietsub",
    },
    {
      title: "Phim thuyết minh",
      url: "/v1/api/danh-sach/phim-thuyet-minh",
    },
    {
      title: "Phim lồng tiếng",
      url: "/v1/api/danh-sach/phim-long-tieng",
    },
    {
      title: "Phim bộ đang chiếu",
      url: "/v1/api/danh-sach/phim-bo-dang-chieu",
    },
    {
      title: "Phim bộ hoàn thành",
      url: "/v1/api/danh-sach/phim-bo-hoan-thanh",
    },
    {
      title: "Phim sắp chiếu",
      url: "/v1/api/danh-sach/phim-sap-chieu",
    },

    {
      title: "Subteam",
      url: "/v1/api/danh-sach/subteam",
    },
  ]);
}
