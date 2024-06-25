#$ using official Bun image
FROM oven/bun:1 as base
WORKDIR /usr/src/app

#$ install deps into temp dir
#$ cache them to speed up future builds
FROM base AS install
RUN mkdir -p /temp/dev
COPY package.json bun.lockb /temp/dev/
RUN cd /temp/dev && bun install --frozen-lockfile

#$ install with --production (excludes dev deps)
RUN mkdir -p /temp/prod
COPY package.json bun.lockb  /temp/prod/
RUN cd /temp/prod && bun install --frozen-lockfile --production

#$ copy node modules from the temp dir
#$ then copy all non-ignored project files into the image
FROM base AS prerelease
COPY --from=install /temp/dev/node_modules node_modules
COPY . .

#$ [ optional ] test & build
ENV NODE_ENV=production
RUN bun test
RUN bun run build

#$ copy prod deps and src code into final image
FROM base AS release
COPY --from=install /temp/prod/node_modules node_modules
COPY --from=prerelease /usr/src/app/index.ts .
COPY --from=prerelease /usr/src/app/package.json .

#$ run the app
USER bun
EXPOSE 3000/tcp
ENTRYPOINT [ "bun", "run", "index.ts" ]
