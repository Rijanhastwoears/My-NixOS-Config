{ lib, python312, fetchFromGitHub }:

python312.pkgs.buildPythonPackage rec {
  pname = "edge-tts";
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "rany2";
    repo = "edge-tts";
    rev = "${version}";
    sha256 = "123kpsimz5dmk85k95b87yr1qa9yxx4fah8hkc4r04627glah9k5";
  };

  format = "pyproject";

  nativeBuildInputs = with python312.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python312.pkgs; [
    aiohttp
    certifi
    srt
    tabulate
    typing-extensions
  ];

  doCheck = false;
  pythonImportsCheck = [ "edge_tts" ];

  meta = with lib; {
    description = "Use Microsoft Edge's online text-to-speech service from Python";
    homepage = "https://github.com/rany2/edge-tts";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
