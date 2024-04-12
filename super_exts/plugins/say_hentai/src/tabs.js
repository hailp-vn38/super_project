async function tabs() {
  return Response.success([
    { title: "Cập Nhật", url: "/" },
    { title: "Manhwa", url: "/genre/manhwa" },
    { title: "Manga", url: "/genre/manga" },
    { title: "Manhua", url: "/genre/manhua" },
  ]);
}
