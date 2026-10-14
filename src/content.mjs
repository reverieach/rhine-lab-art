export const github = 'https://github.com/reverieach/rhine-lab-art';
export const brand = 'RHINE LAB';
export const slogan = 'The shape of a dream.';

// A thematic exhibition, not a chronological retelling. Captions are original fan writing.
const chapters = [
  ['Origin', '8da8bd', 'Vision, Kristen', 'Different dreams once shared a single address. Kristen looks toward a sky whose limits she refuses to accept. What begins as a question becomes an institution. / Lone Trail: CW-10 END.'],
  ['A Name', 'd5a07f', 'Life, Ifrit, Silence', 'She has a name, and a future of her own. In the space between Silence and Ifrit, research acquires a responsibility that no result can erase. / Lone Trail: CW-9 END.'],
  ['Fracture', 'afa6bf', 'Power, Hooleyak', 'Ambition does not belong to science alone. With Hooleyak, knowledge becomes a bargain: the same horizon can conceal very different intentions. / Lone Trail: CW-6 BEG.'],
  ['The Dream', 'b7c6a6', 'Dream, Dorothy', 'What if pain could be kept outside a dream? Dorothy imagines a refuge for people whose lives have been made expendable. The tenderness of that wish makes its cost harder to see. / Dorothy\'s Vision: DV-8 END.'],
  ['The Subjects', '9cbbc1', 'Life, Dorothy', 'Beyond the promise of peace, someone is still waiting to wake. A laboratory can count its subjects; responsibility begins when it sees the people inside those numbers. / Dorothy\'s Vision: DV-6 BEG.'],
  ['Awakening', 'c1b49f', 'Dream, Choice', 'A future cannot be given without the freedom to refuse it. Waking breaks the perfect enclosure and returns uncertainty, pain and possibility to the people who must live with them. / Dorothy\'s Vision: DV-8 END.'],
  ['Horizon', '95afc4', 'Sky, Kristen', 'Another question remains overhead. Beyond the laboratory and its fractures, the sky persists as an unfinished experiment. Every answer makes the boundary more visible. / Dorothy\'s Vision: DV-ST-2.'],
  ['Intersection', 'b4a7bd', 'Life, Saria, Kristen', 'Paths that separated meet again. Shared history survives disagreement, but it cannot make the next decision for either person. / Lone Trail: CW-6 END.'],
  ['Ascent', 'b7c4d1', 'Sky, Kristen', 'All eyes turn toward the same sky. An impossible machine rises on accumulated labor, sacrifice and belief. The dream is singular; its consequences are shared. / Lone Trail: CW-8 END.'],
  ['Parting', 'b2afc8', 'Sky, Saria, Kristen', 'To have travelled together is not to share the final destination. At the threshold, devotion and refusal can look like opposite forms of the same care. / Lone Trail: CW-10 BEG.'],
  ['Daybreak', 'd6b990', 'Life, Dorothy', 'A pause in the ascent: morning returns us to the world below. This memory from Dorothy\'s Vision asks what remains worth protecting, even while someone reaches for the stars. / Dorothy\'s Vision: DV-8 BEG.'],
  ['Farewell', 'a3b8d5', 'Sky, Kristen', 'At last, the imagined distance becomes a view. Discovery opens a world and leaves another behind. The farewell belongs as much to those below as to the traveller. / Lone Trail: CW-ST-4.'],
  ['Belonging', 'b5c8bc', 'Life, Muelsyse', 'Those who remain must also find a way forward. Belonging is neither a perfect institution nor a sealed refuge; it is the possibility of being understood by another person. / Lone Trail: CW-ST-3.'],
  ['The Way Forward', 'c7bba6', 'Life, Silence, Saria', 'The future also begins with a hand offered to someone beside you. After the ascent, Silence and Saria bring the exhibition back to a human scale: care, consequence, and the work that continues. / Lone Trail: CW-ST-3.']
];
const files = ['Avg_38_i04.png','Avg_38_i09.png','Avg_38_i03.png','Avg_29_i06.png','Avg_29_i03.png','Avg_29_i07.png','Avg_29_i10.png','Avg_38_i06.png','Avg_38_i10.png','Avg_38_i08.png','Avg_29_i12.png','Avg_38_i12.png','Avg_38_i05.png','Avg_38_i13.png'];
export const studies = chapters.map(([name, uiColor, tags, description], index) => {
  const number = String(index + 1).padStart(2, '0');
  const slug = name.toLowerCase().replaceAll(' ', '-');
  const thumbnail = `/assets/rhine/${number}.png`;
  return {
    id: `rhine-${number}`, name, slug, description, uiColor, tags,
    clientName: `RHINE LAB / ARCHIVE ${number}`, completionDate: '2026-10-14T00:00:00.000Z',
    priority: index + 1, projectURL: `https://prts.wiki/w/文件:${files[index]}`,
    projectLogo: { url: '/assets/daily/wordmark.png', width: 400, height: 200 },
    video: { url: thumbnail, thumbnail }
  };
});
