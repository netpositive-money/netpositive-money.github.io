export default function (elmLoaded) {
  console.log("Hello outside of promise!");
  elmLoaded.then((elmPagesApp) => {
    console.log("Inside of promise");
  });
}
