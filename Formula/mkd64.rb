# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Mkd64 < Formula
  desc "Modular tool for creating D64 (c64 floppy) disk images"
  homepage "https://zirias.github.io/c64_tool_mkd64/"
  head "https://github.com/Zirias/c64_tool_mkd64.git"

  depends_on "make" => :build

  patch :DATA

  def install
    inreplace "zimk/lib/lib.mk", "-soname", "-install_name"

    make = "#{Formula["make"].opt_bin}/gmake"
    system make, "prefix=#{prefix}", "install"
  end

  test do
    system "dd", "if=/dev/random", "of=#{testpath}/testdata.bin", "bs=1", "count=1000"
    system "#{bin}/mkd64", "-o", "disk.d64", "-m", "cbmdos", "-d", "TEST DISK", "-i", "42", "-g", "-f", "#{testpath}/testdata.bin", "-w"
  end
end

__END__
diff --git a/src/bin/mkd64/mkd64.mk b/src/bin/mkd64/mkd64.mk
index 9bf9cfe..991e5e9 100644
--- a/src/bin/mkd64/mkd64.mk
+++ b/src/bin/mkd64/mkd64.mk
@@ -7,5 +7,5 @@ ifneq ($(plugindir),)
 mkd64_CFLAGS:= -DMODDIR="\"$(plugindir)\""
 endif
-mkd64_posix_LDFLAGS:= -Wl,-E
+mkd64_posix_LDFLAGS:= -Wl,-export_dynamic
 ifneq ($(findstring linux,$(TARGETARCH)),)
 mkd64_posix_LIBS:= dl
diff --git a/src/lib/mkd64/cbmdos/cbmdos.mk b/src/lib/mkd64/cbmdos/cbmdos.mk
index 83c1b8b..9a5c114 100644
--- a/src/lib/mkd64/cbmdos/cbmdos.mk
+++ b/src/lib/mkd64/cbmdos/cbmdos.mk
@@ -3,4 +3,5 @@ cbmdos_LIBTYPE:= plugin
 cbmdos_INSTALLDIRNAME:= plugin
 cbmdos_DEPS:= mkd64
+cbmdos_posix_LDFLAGS:= -Wl,-undefined -Wl,dynamic_lookup
 cbmdos_win32_LIBS:= mkd64
 $(call librules, cbmdos)
diff --git a/src/lib/mkd64/sepgen/sepgen.mk b/src/lib/mkd64/sepgen/sepgen.mk
index 91cfada..a55e494 100644
--- a/src/lib/mkd64/sepgen/sepgen.mk
+++ b/src/lib/mkd64/sepgen/sepgen.mk
@@ -3,4 +3,5 @@ sepgen_LIBTYPE:= plugin
 sepgen_INSTALLDIRNAME:= plugin
 sepgen_DEPS:= mkd64
+sepgen_posix_LDFLAGS:= -Wl,-undefined -Wl,dynamic_lookup
 sepgen_win32_LIBS:= mkd64
 $(call librules, sepgen)
diff --git a/src/lib/mkd64/xtracks/xtracks.mk b/src/lib/mkd64/xtracks/xtracks.mk
index 38af5bc..920a52b 100644
--- a/src/lib/mkd64/xtracks/xtracks.mk
+++ b/src/lib/mkd64/xtracks/xtracks.mk
@@ -3,4 +3,5 @@ xtracks_LIBTYPE:= plugin
 xtracks_INSTALLDIRNAME:= plugin
 xtracks_DEPS:= mkd64
+xtracks_posix_LDFLAGS:= -Wl,-undefined -Wl,dynamic_lookup
 xtracks_win32_LIBS:= mkd64
 $(call librules, xtracks)
