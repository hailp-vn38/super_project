async function tabs() {
  return Response.success([
    {
      title: "Mới cập nhật",
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
  ]);
}
