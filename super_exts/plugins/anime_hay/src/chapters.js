async function chapters(bookUrl) {
  const res = await Extension.request(bookUrl);
  if (!res) return Response.error("Lỗi tải nội dung");

  const chapterEls = await Extension.querySelectorAll(
    res,
    ".list-item-episode a"
  );
  const chapters = [];

  for (var item of chapterEls) {
    var title = await Extension.querySelector(item.content, "a").text;
    chapters.push({
      title: title.trim(),
      url: await Extension.getAttributeText(item.content, "a", "href"),
    });
  }

  return Response.success(chapters.reverse());
}

// runFn(() =>
//   chapters("https://animehay.city/thong-tin-phim/tien-nghich-3879.html")
// );
