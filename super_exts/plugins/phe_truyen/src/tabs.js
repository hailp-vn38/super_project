async function tabs() {
  return Response.success([
    { title: "Truyện mới cập nhật", url: "/latest-update" },
    { title: "Truyện mới", url: "/new-stories" },
    { title: "Truyện Full", url: "/completed" },
  ]);
}
