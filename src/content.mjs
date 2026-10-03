export const github = 'https://github.com/Snychng/daily-design';
export const brand = 'Daily Design .Art';
export const slogan = 'Explore the art of UI, one day at a time.';

// 前六项来自工作区实验；其余为 UI/UX 概念研究，均不声称商业交付。
export const studies = [
  ['Dispersion', 'dispersion', 'e9ae98', 'UI, Optics, Glass', 'A study of optical distortion: a glass surface shifts the image beneath it, while subtle color fringes reveal its edges.'],
  ['Star Ring', 'star-ring', '88a9d1', 'UX, Space, Motion', 'Circular planes move through a shared spatial orbit. Near and far surfaces trade places, making depth visible through scale and occlusion.'],
  ['Gallery', 'gallery', 'd3c7b8', 'UI, Typography, Motion', 'An editorial carousel moves between front-facing artwork and edge-on silhouettes. Reflections turn the boundaries into part of the composition.'],
  ['Orbit', 'orbit', 'a3c4b1', 'UX, Interaction, Space', 'A selected card leaves a tilted orbit, turns toward the viewer and returns to its place. The transition connects exploration and focus.'],
  ['Glass Slingshot', 'slingshot', 'e5ab92', 'UX, Physics, Feedback', 'A glass track bends under a dragged marble. Release turns stored tension into a small arc of motion, followed by a grounded return.'],
  ['Genesis', 'genesis', 'b4b5bc', 'UI, Light, Motion', 'A small light core opens into a new visual space. Brightness, scale and contrast carry the eye through the transition.'],
  ['Optic Type', 'dispersion', 'd5b8ae', 'UI, Typography, Optics', 'A concept study of type seen through a refractive surface. Optical detail supports the reading rhythm and keeps the words clear.'],
  ['Liquid Feedback', 'slingshot', 'dca391', 'UX, Feedback, Glass', 'A concept study of tactile feedback. A small change in tension, shape and reflection makes the state of a control easier to understand.'],
  ['Focus Field', 'orbit', 'b2c6b6', 'UX, Space, Interaction', 'A concept study of focus in a spatial interface. Selection brings one object closer while retaining a clear path back to the collection.'],
  ['Afterimage', 'gallery', 'c5becb', 'UI, Typography, Motion', 'A concept study of editorial pacing. Type, image and reflection move together, leaving a brief visual trace between one composition and the next.'],
  ['Material Lab', 'dispersion', '94adca', 'UI, Optics, Glass', 'A concept study of surface, depth and legibility. Glass reveals the image below it through distortion and carefully placed highlights.'],
  ['Spatial Notes', 'star-ring', 'a7b7cb', 'UX, Space, Typography', 'A concept study of arranging ideas in depth. Scale, overlap and camera distance create a readable sequence without losing the surrounding context.'],
  ['Gesture Studies', 'slingshot', 'e7b49f', 'UX, Interaction, Physics', 'A concept study of gesture and consequence. A control responds to the direction of a drag, carries its momentum and settles into a clear final state.'],
  ['Light Studies', 'genesis', 'c6c1be', 'UI, Light, Motion', 'A concept study of light as a transition. A focused highlight expands into another scene, connecting two compositions through a shared point of attention.']
].map(([name, cover, uiColor, tags, description], index) => ({
  id: `daily-study-${index + 1}`,
  name, slug: name.toLowerCase().replaceAll(' ', '-'), description,
  clientName: index < 6 ? 'Daily Design .Art / Experiment' : 'Daily Design .Art / Concept',
  completionDate: '2026-09-30T00:00:00.000Z', uiColor, tags,
  priority: index + 1, projectURL: github,
  projectLogo: { url: '/assets/daily/wordmark.png', width: 400, height: 200 },
  // 原 WorkItem 以媒体 URL 判断当前卡片；每项保持唯一 URL，避免同时激活复用封面的卡片。
  video: { url: `/assets/daily/study-${name.toLowerCase().replaceAll(' ', '-')}.jpg`, thumbnail: `/assets/daily/cover-${cover}.jpg` }
}));
