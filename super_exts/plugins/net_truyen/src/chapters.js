async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  if (!res) return Response.error("Có lỗi khi lấy danh sách chương");
  const els = await Extension.querySelectorAll(res, "#nt_listchapter li");

  const chapters = [];

  for (var item of els) {
    var title = await Extension.querySelector(item.content, "a").text;
    chapters.push({
      name: title.trim(),
      url: await Extension.getAttributeText(item.content, "a", "href"),
    });
  }
  return Response.success(chapters.reverse());
}

// runFn(() =>
//   chapters(
//     "https://www.nettruyenee.com/truyen-tranh/xuyen-nhanh-phan-dien-qua-sung-qua-me-nguoi-88810"
//   )
// );
