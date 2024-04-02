async function genre(url) {
  const res = await Extension.request(url + "/v1/api/the-loai");
  if (!res) return Response.error("Có lỗi khi tải nội dung");

  if (!res.status == "success") {
    return Response.error("Có lỗi khi tải nội dung");
  }

  let result = [];
  for (const item of res.data.items) {
    result.push({
      title: item.name,
      url: "/v1/api/the-loai/" + item.slug,
    });
  }
  return Response.success(result);
}

// runFn(() => genre("https://ophim1.com"));
