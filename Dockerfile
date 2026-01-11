# Çalışan imajı baz alıyoruz
FROM ghcr.io/hdl/conda:latest

# GHDL, Yosys ve SymbiYosys'i kuruyoruz (Tek seferlik işlem)
RUN conda install -y -c conda-forge -c litex-hub \
    ghdl \
    yosys \
    symbiyosys \
    && conda clean -afy

WORKDIR /work
COPY . /work

# Varsayılan komut
CMD ["python3", "run.py", "-v"]
