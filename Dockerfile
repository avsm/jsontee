FROM ocaml/opam:alpine
COPY . /home/opam/src
RUN sudo chown -R opam /home/opam/src && \
    opam pin add -n jsontee /home/opam/src && \
    opam depext -ui jsontee
ENTRYPOINT ["opam","config","exec","--","jsontee"]
